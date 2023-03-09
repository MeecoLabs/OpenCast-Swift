import Foundation

public protocol CastDiscoveryDelegate: AnyObject {
    func castDiscoveryDidStart(_ discovery: CastDiscovery)
    func castDiscoveryFailed(_ discovery: CastDiscovery, error: Error)
    func castDiscoveryDidStop(_ discovery: CastDiscovery)
    func castDiscovery(_ discovery: CastDiscovery, didFind device: CastDevice)
    func castDiscovery(_ discovery: CastDiscovery, didUpdate device: CastDevice)
    func castDiscovery(_ discovery: CastDiscovery, didRemove device: CastDevice)
}

public extension CastDiscoveryDelegate {
    func castDiscoveryDidStart(_ discovery: CastDiscovery) {}
    func castDiscoveryFailed(_ discovery: CastDiscovery, error: Error) {}
    func castDiscoveryDidStop(_ discovery: CastDiscovery) {}
    func castDiscovery(_ discovery: CastDiscovery, didFind device: CastDevice) {}
    func castDiscovery(_ discovery: CastDiscovery, didUpdate device: CastDevice) {}
    func castDiscovery(_ discovery: CastDiscovery, didRemove device: CastDevice) {}
}
