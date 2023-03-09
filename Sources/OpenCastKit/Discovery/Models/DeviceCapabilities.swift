import Foundation

public struct DeviceCapabilities: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
      
    public static let none = DeviceCapabilities([])
    public static let videoOut = DeviceCapabilities(rawValue: 1 << 0)
    public static let videoIn = DeviceCapabilities(rawValue: 1 << 1)
    public static let audioOut = DeviceCapabilities(rawValue: 1 << 2)
    public static let audioIn = DeviceCapabilities(rawValue: 1 << 3)
    public static let multizoneGroup = DeviceCapabilities(rawValue: 1 << 5)
    public static let masterVolume = DeviceCapabilities(rawValue: 1 << 11)
    public static let attenuationVolume = DeviceCapabilities(rawValue: 1 << 12)
}
