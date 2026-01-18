import Foundation
import DeviceKit

enum DeviceInfo {
    static func modelName() -> String {
        Device.current.description
    }
}
