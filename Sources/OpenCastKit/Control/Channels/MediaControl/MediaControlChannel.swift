//
//  MediaControlChannel.swift
//  
//
//  Created by Dustin Steiner on 22/02/2023.
//

import Foundation

private let Namespace = "urn:x-cast:com.google.cast.media"

//public enum CastMediaStreamType: String, Encodable {
//    case buffered = "BUFFERED"
//    case live = "LIVE"
//}
//
//struct CastMediaImage: Encodable {
//    let url: String
//    let width: Int? = nil
//    let height: Int? = nil
//}
//
//enum CastMediaMetadataType: Int, Encodable {
//    case generic = 0
//    case movie = 1
//    case tvShow = 2
//    case musicTrack = 3
//    case photo = 4
//    case audiobookChapter = 5
//}
//
//public struct CastMediaMetadata: Encodable {
//    let type: CastMediaMetadataType
//    let metadataType: CastMediaMetadataType
//
//    // Generic
//    let title: String?
//    let subtitle: String?
//    let releaseDate: String?
//    let images: [CastMediaImage]?
//    //let contentRating: String
//
//    // Movie
//    let studio: String?
//
//    // TV Show
//    let seriesTitle: String?
//    let season: Int?
//    let episode: Int?
//    let originalAirdate: String?
//
//    public init(title: String?, subtitle: String?, releaseDate: String?, poster: URL?) {
//        self.type = .generic
//        self.metadataType = .generic
//        self.title = title
//        self.subtitle = subtitle
//        self.releaseDate = releaseDate
//        if let poster {
//            self.images = [CastMediaImage(url: poster.absoluteString)]
//        } else {
//            images = nil
//        }
//
//        self.studio = nil
//        self.seriesTitle = nil
//        self.season = nil
//        self.episode = nil
//        self.originalAirdate = nil
//    }
//
//    public init(title: String?, subtitle: String?, studio: String?, releaseDate: String?, poster: URL?) {
//        self.type = .movie
//        self.metadataType = .movie
//        self.title = title
//        self.subtitle = subtitle
//        self.studio = studio
//        self.releaseDate = releaseDate
//        if let poster {
//            self.images = [CastMediaImage(url: poster.absoluteString)]
//        } else {
//            images = nil
//        }
//
//        self.seriesTitle = nil
//        self.season = nil
//        self.episode = nil
//        self.originalAirdate = nil
//    }
//
//    public init(seriesTitle: String?, title: String?, season: Int?, episode: Int?, originalAirdate: String?, poster: URL?) {
//        self.type = .tvShow
//        self.metadataType = .tvShow
//        self.seriesTitle = seriesTitle
//        self.title = title
//        self.season = season
//        self.episode = episode
//        self.originalAirdate = originalAirdate
//        if let poster {
//            self.images = [CastMediaImage(url: poster.absoluteString)]
//        } else {
//            images = nil
//        }
//
//        self.subtitle = nil
//        self.releaseDate = nil
//        self.studio = nil
//    }
//}
//
//public struct CastMediaTrack: Encodable {
//    let trackId: String
//    let trackContentId: String
//    let language: String
//    let subtype: String = "SUBTITLES"
//    let type: String = "TEXT"
//    let trackContentType: String
//    let name: String
//
//    public init(url: URL, contentType: String, language: String) {
//        trackId = url.absoluteString
//        trackContentId = url.absoluteString
//        self.language = language
//        trackContentType = contentType
//        name = language
//    }
//}
//
//public struct CastMedia: Encodable {
//    let contentId: String
//    let contentType: String
//    let streamType: CastMediaStreamType
//    let metadata: CastMediaMetadata
//    let tracks: [CastMediaTrack]
//
//    public init(url: URL, contentType: String, streamType: CastMediaStreamType, metadata: CastMediaMetadata, subtitle: CastMediaTrack?) {
//        contentId = url.absoluteString
//        self.contentType = contentType
//        self.streamType = streamType
//        self.metadata = metadata
//        if let subtitle {
//            tracks = [subtitle]
//        } else {
//            tracks = []
//        }
//    }
//}

public class MediaControlChannel: CastChannel {
    private var delegate: MediaControlChannelDelegate? {
        return requestDispatcher as? MediaControlChannelDelegate
    }
    
    public init() {
        super.init(namespace: Namespace)
    }
    
    public override func handleResponse(_ json: NSDictionary, sourceId: String) {
        guard let rawType = json["type"] as? String else {
            return
        }
        
        switch rawType {
            case "MEDIA_STATUS":
                guard let statuses = json["status"]  as? [NSDictionary],
                      let status = statuses.first
                else {
                    return
                }
                
                delegate?.channel(self, didReceive: CastMediaStatus(json: status))
                
            default:
                print("MediaControlChannel.handleResponse: unknown type = \(rawType)")
        }
    }
    
    public func requestMediaStatus(for app: CastApp, completion: ((Result<CastMediaStatus, CastError>) -> Void)? = nil) {
        let payload = GetStatusPayload(sessionId: app.sessionId)
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: app.transportId,
                                                payload: payload)
        
        if let completion {
            send(request) { result in
                switch result {
                    case .success(let json):
                        completion(Result.success(CastMediaStatus(json: json)))
                        
                    case .failure(let error):
                        completion(Result.failure(error))
                }
            }
        } else {
            send(request)
        }
    }
    
    public func sendPause(for app: CastApp, mediaSessionId: Int) {
        let payload = PausePayload(mediaSessionId: mediaSessionId)
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: app.transportId,
                                                payload: payload)
        send(request)
    }
    
    public func sendPlay(for app: CastApp, mediaSessionId: Int) {
        let payload = PlayPayload(mediaSessionId: mediaSessionId)
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: app.transportId,
                                                payload: payload)
        send(request)
    }
    
    public func sendStop(for app: CastApp, mediaSessionId: Int) {
        let payload = StopPayload(mediaSessionId: mediaSessionId)
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: app.transportId,
                                                payload: payload)
        send(request)
    }
    
    public func sendSeek(to currentTime: Float, for app: CastApp, mediaSessionId: Int) {
        let payload = SeekPayload(sessionId: app.sessionId, currentTime: currentTime, mediaSessionId: mediaSessionId)
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: app.transportId,
                                                payload: payload)
        send(request)
    }
    
    public func load(media: CastMedia, with app: CastApp, completion: @escaping (Result<CastMediaStatus, CastError>) -> Void) {
        let payload = LoadPayload(sessionId: app.sessionId, activeTrackIds: media.activeTrackIds, autoplay: media.autoplay, credentials: media.credentials, credentialsType: media.credentialsType, currentTime: media.currentTime, loadOptions: media.loadOptions, media: media.media, mediaSessionId: media.mediaSessionId, playbackRate: media.playbackRate, queueData: media.queueData)
        let request = requestDispatcher.request(withNamespace: namespace,
                                                destinationId: app.transportId,
                                                payload: payload)

        send(request) { result in
            switch result {
                case .success(let json):
                    guard let statuse = json["status"] as? [NSDictionary],
                          let status = statuse.first
                    else {
                        return
                    }
                    completion(.success(CastMediaStatus(json: status)))
            
                case .failure(let error):
                    completion(.failure(CastError.load(error.localizedDescription)))
            }
        }
    }
}
