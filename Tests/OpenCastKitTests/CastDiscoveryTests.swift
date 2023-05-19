import XCTest
import Network
@testable import OpenCastKit

private class MockBonjourBrowser: BonjourBrowser {
    var stateUpdateHandler: ((NWBrowser.State) -> Void)?
    
    var browseResultsChangedHandler: ((Set<NWBrowser.Result>, Set<NWBrowser.Result.Change>) -> Void)?
    
    private(set) var startCalled = 0
    private(set) var cancelCalled = 0
    
    func start(queue: DispatchQueue) {
        startCalled += 1
    }
    
    func cancel() {
        cancelCalled += 1
    }
}

private class MockDiscoveryDelegate: CastDiscoveryDelegate {
    private(set) var startCalled = 0
    private(set) var stopCalled = 0
    private(set) var failedCalled = 0
    private(set) var foundDevices = 0
    private(set) var updatedDevices = 0
    private(set) var removedDevices = 0
    
    func castDiscoveryDidStart(_ discovery: CastDiscovery) {
        startCalled += 1
    }
    
    func castDiscoveryDidStop(_ discovery: CastDiscovery) {
        stopCalled += 1
    }
    
    func castDiscovery(_ discovery: CastDiscovery, didFind device: CastDevice) {
        foundDevices += 1
    }
    
    func castDiscovery(_ discovery: CastDiscovery, didUpdate device: CastDevice) {
        updatedDevices += 1
    }
    
    func castDiscovery(_ discovery: CastDiscovery, didRemove device: CastDevice) {
        removedDevices += 1
    }
    
    func castDiscoveryFailed(_ discovery: CastDiscovery, error: Error) {
        failedCalled += 1
    }
}

final class CastDiscoveryTests: XCTestCase {
    private var browser: MockBonjourBrowser!
    private var discovery: CastDiscovery!
    private var delegate: MockDiscoveryDelegate!
    
    override func setUp() {
        let browser = MockBonjourBrowser()
        self.browser = browser
        discovery = CastDiscovery(browserFactory: { browser })
        delegate = MockDiscoveryDelegate()
        discovery.delegate = delegate
    }
    
    func testStart() throws {
        discovery.start()
        
        XCTAssertNotNil(browser.stateUpdateHandler)
        XCTAssertNotNil(browser.browseResultsChangedHandler)
        XCTAssertEqual(browser.startCalled, 1)
        XCTAssertEqual(browser.cancelCalled, 0)
    }
    
    func testCancel() throws {
        discovery.start()
        
        discovery.stop()
        
        XCTAssertNil(browser.stateUpdateHandler)
        XCTAssertNil(browser.browseResultsChangedHandler)
        XCTAssertEqual(browser.startCalled, 1)
        XCTAssertEqual(browser.cancelCalled, 1)
    }
    
    func testDelegateDidStartCalled() throws {
        discovery.start()
        
        browser.stateUpdateHandler?(.ready)
        
        XCTAssertEqual(delegate.startCalled, 1)
        XCTAssertEqual(delegate.stopCalled, 0)
        XCTAssertEqual(delegate.failedCalled, 0)
        XCTAssertEqual(delegate.foundDevices, 0)
        XCTAssertEqual(delegate.updatedDevices, 0)
        XCTAssertEqual(delegate.removedDevices, 0)
    }
    
    func testDelegateDidStopCalled() throws {
        discovery.start()
        
        browser.stateUpdateHandler?(.cancelled)
        
        XCTAssertEqual(delegate.startCalled, 0)
        XCTAssertEqual(delegate.stopCalled, 1)
        XCTAssertEqual(delegate.failedCalled, 0)
        XCTAssertEqual(delegate.foundDevices, 0)
        XCTAssertEqual(delegate.updatedDevices, 0)
        XCTAssertEqual(delegate.removedDevices, 0)
    }
    
    func testDelegateDidFailCalled() throws {
        discovery.start()
        
        browser.stateUpdateHandler?(.failed(NWError.dns(0)))
        
        XCTAssertEqual(delegate.startCalled, 0)
        XCTAssertEqual(delegate.stopCalled, 0)
        XCTAssertEqual(delegate.failedCalled, 1)
        XCTAssertEqual(delegate.foundDevices, 0)
        XCTAssertEqual(delegate.updatedDevices, 0)
        XCTAssertEqual(delegate.removedDevices, 0)
    }
}
