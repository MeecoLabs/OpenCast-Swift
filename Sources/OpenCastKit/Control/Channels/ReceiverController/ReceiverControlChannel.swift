//
//  ReceiverControlChannel.swift
//
//
//  Created by Dustin Steiner on 22/02/2023.
//

import Foundation

private let Namespace = "urn:x-cast:com.google.cast.receiver"

struct RequestStatusPayload: CastJSONPayload {
    var requestId: Int?
    let type = "GET_STATUS"
}

public struct CastAppIdentifier {
    public static let defaultMediaPlayer = "CC1AD845"
    public static let youTube = "YouTube"
    public static let googleAssistant = "97216CB6"
}

public struct CastApp: Decodable {
    public let id: String
    public let appType: String
    public let displayName: String
    public let iconUrl: String
    public let isIdleScreen: Bool
    public let launchedFromCloud: Bool
    public let sessionId: String
    public let statusText: String
    public let transportId: String
    public let universalAppId: String
    public let namespaces: [String]
}

extension CastApp {
    init(json: NSDictionary) {
        id = json["appId"] as? String ?? ""
        appType = json["appType"] as? String ?? ""
        displayName = json["displayName"] as? String ?? ""
        iconUrl = json["iconUrl"] as? String ?? ""
        isIdleScreen = json["isIdleScreen"] as? Bool ?? false
        launchedFromCloud = json["launchedFromCloud"] as? Bool ?? false
        sessionId = json["sessionId"] as? String ?? ""
        statusText = json["statusText"] as? String ?? ""
        transportId = json["transportId"] as? String ?? ""
        universalAppId = json["universalAppId"] as? String ?? ""
        if let namespaces = json["namespaces"] as? [[String: String]] {
            self.namespaces = namespaces.compactMap { $0["name"] }
        } else {
            namespaces = []
        }
    }
}

public struct CastVolume: Decodable {
    public let controlType: String
    public let level: Double
    public let muted: Bool
    public let stepInterval: Double
}

extension CastVolume {
    init(json: NSDictionary) {
        controlType = json["controlType"] as? String ?? ""
        level = json["level"] as? Double ?? 1
        muted = json["muted"] as? Bool ?? false
        stepInterval = json["stepInterval"] as? Double ?? 0.1
    }
}

public struct CastStatus: Decodable {
    public let volume: CastVolume
    public let isActiveInput: Bool
    public let isStandBy: Bool
    public let apps: [CastApp]
}

extension CastStatus {
    init?(json: NSDictionary) {
        guard let status = json["status"] as? NSDictionary else {
            return nil
        }
        
        if let volume = status["volume"] as? NSDictionary {
            self.volume = CastVolume(json: volume)
        } else {
            volume = CastVolume(controlType: "fixed", level: 1, muted: false, stepInterval: 0.1)
        }
        isActiveInput = status["isActiveInput"] as? Bool ?? false
        isStandBy = status["isStandBy"] as? Bool ?? false
        if let apps = status["applications"] as? [NSDictionary] {
            self.apps = apps.compactMap { CastApp(json: $0) }
        } else {
            apps = []
        }
    }
}

public struct AppAvailability: Decodable {
    public let availability: [String: Bool]
}

extension AppAvailability {
    init(json: NSDictionary) {
        if let availability = json["availability"] as? [String: String] {
            self.availability = availability.mapValues { $0 == "APP_AVAILABLE" }
        } else {
            self.availability = [String: Bool]()
        }
    }
}

struct AppAvailabilityPayload: CastJSONPayload {
    var requestId: Int?
    let type = "GET_APP_AVAILABILITY"
    let appId: [String]
}

struct LaunchAppPayload: CastJSONPayload {
    var requestId: Int?
    let type = "LAUNCH"
    let appId: String
}

class ReceiverControlChannel: CastChannel {
    override weak var requestDispatcher: RequestDispatchable! {
        didSet {
            if requestDispatcher != nil {
                requestStatus()
            }
        }
    }
    
    private var delegate: ReceiverControlChannelDelegate? {
        return requestDispatcher as? ReceiverControlChannelDelegate
    }
      
    
    public init() {
        super.init(namespace: Namespace)
    }
    
    override func handleResponse(_ json: NSDictionary, sourceId: String) {
        guard let rawType = json["type"] as? String else {
            return
        }
            
        switch rawType {
            case "RECEIVER_STATUS":
              delegate?.channel(self, didReceive: CastStatus(json: json)!)
              
            default:
              print("ReceiverControlChannel.handleResponse: unknown type = \(rawType)")
        }
    }
    
    public func getAppAvailability(apps: [String], completion: @escaping (Result<AppAvailability, CastError>) -> Void) {
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: CastConstants.receiver,
                                                payload: AppAvailabilityPayload(appId: apps))
        
        send(request) { result in
            switch result {
                case .success(let json):
                    completion(Result.success(AppAvailability(json: json)))
          
                case .failure(let error):
                    completion(Result.failure(CastError.launch(error.localizedDescription)))
            }
        }
    }
    
    public func requestStatus(completion: ((Result<CastStatus, CastError>) -> Void)? = nil) {
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: CastConstants.receiver,
                                                payload: RequestStatusPayload())
        
        if let completion = completion {
            send(request) { result in
                switch result {
                    case .success(let json):
                        completion(.success(CastStatus(json: json)!))

                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        } else {
            send(request)
        }
    }
    
    public func launch(appId: String, completion: @escaping (Result<CastApp, CastError>) -> Void) {
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: CastConstants.receiver,
                                                payload: LaunchAppPayload(appId: appId))
        
        send(request) { result in
            switch result {
                case .success(let json):
                    guard let app = CastStatus(json: json)?.apps.first else {
                        completion(.failure(CastError.launch("Unable to get launched app instance")))
                        return
                    }
                    completion(.success(app))

                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
