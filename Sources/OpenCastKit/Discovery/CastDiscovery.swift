import Foundation
import Network

private let GoogleCastMDNSServiceName = "_googlecast._tcp"

public class CastDiscovery {
    private var browser: NWBrowser?
    
    public weak var delegate: CastDiscoveryDelegate?
    
    public init() {
    }
    
    deinit {
        if browser != nil {
            stop()
        }
    }
    
    public func start() {
        print("CastDiscovery.start")
        if browser == nil {
            let parameter = NWParameters()
            browser = NWBrowser(for: .bonjourWithTXTRecord(type: GoogleCastMDNSServiceName, domain: nil), using: parameter)
            browser!.stateUpdateHandler = self.onDiscoveryStateUpdate
            browser!.browseResultsChangedHandler = self.onDiscoveryBrowseResultsChangedUpdate
            browser!.start(queue: .global())
        }
    }
    
    public func stop() {
        print("CastDiscovery.stop")
        browser?.cancel()
        browser = nil
    }
    
    private func onDiscoveryStateUpdate(_ state: NWBrowser.State) {
        print("CastDiscovery.onDiscoveryStateUpdate: state = \(state)")
        switch state {
            case .ready:
                delegate?.castDiscoveryDidStart(self)
                
            case .cancelled:
                delegate?.castDiscoveryDidStop(self)
                
            case .failed(let error):
                delegate?.castDiscoveryFailed(self, error: error)
                
            default:
                break
        }
    }
    
    private func onDiscoveryBrowseResultsChangedUpdate(_ results: Set<NWBrowser.Result>, _ changes: Set<NWBrowser.Result.Change>) {
        print("CastDiscovery.onDiscoveryBrowseResultsChangedUpdate: results = \(results), changes = \(changes)")
        for change in changes {
            switch change {
                case .added(let result):
                    guard let receiver = CastDevice(from: result) else {
                        break
                    }
                    delegate?.castDiscovery(self, didFind: receiver)
                    
                case .changed(old: _, new: let newResult, flags: _):
                    guard let receiver = CastDevice(from: newResult) else {
                        break
                    }
                    delegate?.castDiscovery(self, didUpdate: receiver)
                    
                case .removed(let result):
                    guard let receiver = CastDevice(from: result) else {
                        break
                    }
                    delegate?.castDiscovery(self, didRemove: receiver)
                    
                default:
                    break
            }
        }
    }
}
