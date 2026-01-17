import Combine
import Foundation

final class UserDefaultsFamilyIdStore: FamilyIdStore {
    private let defaults: UserDefaults
    private let key = "familyId"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save(familyId: String) {
        defaults.set(familyId, forKey: key)
    }

    func get() -> String? {
        defaults.string(forKey: key)
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}
