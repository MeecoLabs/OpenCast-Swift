//
//  ReceiverControlChannel.swift
//
//
//  Created by Dustin Steiner on 22/02/2023.
//

import Foundation

private let Namespace = "urn:x-cast:com.google.cast.receiver"

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
                delegate?.channel(self, didReceive: ReceiverStatusPayload(json: json).status)
              
            default:
                print("ReceiverControlChannel.handleResponse: unknown type = \(rawType)")
        }
    }
    
    public func getAppAvailability(apps: [String], completion: @escaping (Result<AppAvailability, CastError>) -> Void) {
        let payload = AppAvailabilityPayload(appId: apps)
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: CastConstants.receiver,
                                                payload: payload)
        
        send(request) { result in
            switch result {
                case .success(let json):
                    completion(Result.success(AppAvailability(json: json)))
          
                case .failure(let error):
                    completion(Result.failure(CastError.launch(error.localizedDescription)))
            }
        }
    }
    
    public func requestStatus(completion: ((Result<ReceiverStatus, CastError>) -> Void)? = nil) {
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: CastConstants.receiver,
                                                payload: GetReceiverStatusPayload())
        
        if let completion = completion {
            send(request) { result in
                switch result {
                    case .success(let json):
                        completion(.success(ReceiverStatus(json: json)))

                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        } else {
            send(request)
        }
    }
    
    public func launch(appId: String, completion: @escaping (Result<ReceiverApp, CastError>) -> Void) {
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: CastConstants.receiver,
                                                payload: LaunchAppPayload(appId: appId))
        
        send(request) { result in
            switch result {
                case .success(let json):
                    guard let app = ReceiverStatus(json: json).applications?.first else {
                        completion(.failure(CastError.launch("Unable to get launched app instance")))
                        return
                    }
                    completion(.success(app))

                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    public func stop(app: ReceiverApp) {
        stop(app: app.sessionId)
    }
    
    public func stop(app sessionId: String) {
        let payload = StopAppPayload(sessionId: sessionId)
        let request = requestDispatcher.request(withNamespace: namespace,
                                               destinationId: CastConstants.receiver,
                                               payload: payload)
            
        send(request)
    }
    
    public func setVolume(_ volume: Float) {
        let payload = VolumeRequest(volume: SetVolume(level: volume, muted: nil))
        let request = requestDispatcher.request(withNamespace: namespace,
                                         destinationId: CastConstants.receiver,
                                         payload: payload)
        send(request)
    }
    
    public func setMuted(_ isMuted: Bool) {
        let payload = VolumeRequest(volume: SetVolume(level: nil, muted: isMuted))
        let request = requestDispatcher.request(withNamespace: namespace,
                                         destinationId: CastConstants.receiver,
                                         payload: payload)
        send(request)
    }
}
