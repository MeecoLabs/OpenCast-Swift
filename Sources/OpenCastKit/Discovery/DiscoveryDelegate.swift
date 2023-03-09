import Foundation

public protocol DiscoveryDelegate: AnyObject {
    func discoveryDidStart(_ discovery: Discovery)
    func discoveryFailed(_ discovery: Discovery, error: Error)
    func discoveryDidStop(_ discovery: Discovery)
    func discovery(_ discovery: Discovery, didFind device: CastDevice)
    func discovery(_ discovery: Discovery, didUpdate device: CastDevice)
    func discovery(_ discovery: Discovery, didRemove device: CastDevice)
}

public extension DiscoveryDelegate {
    func discoveryDidStart(_ discovery: Discovery) {}
    func discoveryFailed(_ discovery: Discovery, error: Error) {}
    func discoveryDidStop(_ discovery: Discovery) {}
    func discovery(_ discovery: Discovery, didFind device: CastDevice) {}
    func discovery(_ discovery: Discovery, didUpdate device: CastDevice) {}
    func discovery(_ discovery: Discovery, didRemove device: CastDevice) {}
}
