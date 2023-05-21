import XCTest
import Network
@testable import OpenCastKit

private struct TestError: Error {}

private class AwaitableCastDiscoveryDelegate: CastDiscoveryDelegate {
    var continuation: CheckedContinuation<CastDevice, Error>?
    
    func castDiscovery(_ discovery: CastDiscovery, didFind device: CastDevice) {
        continuation?.resume(returning: device)
        continuation = nil
    }
    
    func castDiscoveryFailed(_ discovery: CastDiscovery, error: Error) {
        continuation?.resume(throwing: TestError())
        continuation = nil
    }
}

private class AwaitableCastControlDelegate: CastControlDelegate {
    var continuation: CheckedContinuation<CastDevice, Never>?
    
    func castControl(_ client: CastControl, didConnectTo device: CastDevice) {
        continuation?.resume(returning: device)
        continuation = nil
    }
}

final class CastControlTests: XCTestCase {
    private var discovery: CastDiscovery!
    private var discoveryDelegate: AwaitableCastDiscoveryDelegate!
    private var control: CastControl!
    private var controlDelegate: AwaitableCastControlDelegate!
    
    override func setUp() {
        discovery = CastDiscovery()
        discoveryDelegate = AwaitableCastDiscoveryDelegate()
        discovery.delegate = discoveryDelegate
        controlDelegate = AwaitableCastControlDelegate()
    }
    
    func testDiscovery() async throws {
        let device = try await withCheckedThrowingContinuation({ continuation in
            discoveryDelegate.continuation = continuation
            discovery.start()
        })
        
        discovery.stop()
        
        XCTAssertNotNil(device)
    }
    
    func testConnect() async throws {
        let device = try await withCheckedThrowingContinuation({ continuation in
            discoveryDelegate.continuation = continuation
            discovery.start()
        })
        discovery.stop()
        
        control = CastControl(device: device)
        control.delegate = controlDelegate
        
        let connectedDevice = await withCheckedContinuation({ continuation in
            controlDelegate.continuation = continuation
            control.connect()
        })
        
        XCTAssertNotNil(connectedDevice)
    }
}
