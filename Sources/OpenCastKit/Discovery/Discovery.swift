import Foundation
import Network

private let GoogleCastMDNSServiceName = "_googlecast._tcp"

public class Discovery {
    private var browser: NWBrowser?
    
    public weak var delegate: DiscoveryDelegate?
    
    public init() {
    }
    
    deinit {
        if browser != nil {
            stop()
        }
    }
    
    public func start() {
        print("Discovery.start")
        if browser == nil {
            let parameter = NWParameters()
            browser = NWBrowser(for: .bonjourWithTXTRecord(type: GoogleCastMDNSServiceName, domain: nil), using: parameter)
            browser!.stateUpdateHandler = self.onDiscoveryStateUpdate
            browser!.browseResultsChangedHandler = self.onDiscoveryBrowseResultsChangedUpdate
            browser!.start(queue: .global())
        }
    }
    
    public func stop() {
        print("Discovery.stop")
        browser?.cancel()
        browser = nil
    }
    
    private func onDiscoveryStateUpdate(_ state: NWBrowser.State) {
        print("Discovery.onDiscoveryStateUpdate: state = \(state)")
        switch state {
            case .ready:
                delegate?.discoveryDidStart(self)
                
            case .cancelled:
                delegate?.discoveryDidStop(self)
                
            case .failed(let error):
                delegate?.discoveryFailed(self, error: error)
                
            default:
                break
        }
    }
    
    private func onDiscoveryBrowseResultsChangedUpdate(_ results: Set<NWBrowser.Result>, _ changes: Set<NWBrowser.Result.Change>) {
        print("Discovery.onDiscoveryBrowseResultsChangedUpdate: results = \(results), changes = \(changes)")
        for change in changes {
            switch change {
                case .added(let result):
                    guard let receiver = CastDevice(from: result) else {
                        break
                    }
                    delegate?.discovery(self, didFind: receiver)
                    
                case .changed(old: _, new: let newResult, flags: _):
                    guard let receiver = CastDevice(from: newResult) else {
                        break
                    }
                    delegate?.discovery(self, didUpdate: receiver)
                    
                case .removed(let result):
                    guard let receiver = CastDevice(from: result) else {
                        break
                    }
                    delegate?.discovery(self, didRemove: receiver)
                    
                default:
                    break
            }
        }
    }
}
