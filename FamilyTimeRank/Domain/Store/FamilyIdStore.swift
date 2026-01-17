import Foundation

protocol FamilyIdStore {
    func save(familyId: String)
    func get() -> String?
    func clear()
}
