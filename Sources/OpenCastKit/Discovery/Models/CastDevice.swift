import Foundation
import Network

public struct CastDevice: Identifiable {
    public let id: String
    public let friendlyName: String
    public let model: String
    public let capabilities: DeviceCapabilities
    public let status: String?
    public let icon: String?
    public let endpoint: NWEndpoint
    //let bs: String
    //let st: String
    //let nf: String
    //let rm: String?
    //let ve: String
    
    public init(id: String, friendlyName: String, model: String, capabilitiesMask: Int, status: String?, icon: String?, endpoint: NWEndpoint) {
        self.id = id
        self.friendlyName = friendlyName
        self.model = model
        self.capabilities = DeviceCapabilities(rawValue: capabilitiesMask)
        self.status = status
        self.icon = icon
        self.endpoint = endpoint
    }
}

extension CastDevice {
    init?(from result: NWBrowser.Result) {
        guard case let .bonjour(metadata) = result.metadata else {
            return nil
        }
        
        guard let id = metadata["id"],
              let friendlyName = metadata["fn"],
              let model = metadata["md"]
        else {
            return nil
        }
        
        let capabilitiesMask = metadata["ca"].flatMap(Int.init) ?? 0
        let status = metadata["rs"]
        let icon = metadata["ic"]
        
        self.init(id: id, friendlyName: friendlyName, model: model, capabilitiesMask: capabilitiesMask, status: status, icon: icon, endpoint: result.endpoint)
    }
}
