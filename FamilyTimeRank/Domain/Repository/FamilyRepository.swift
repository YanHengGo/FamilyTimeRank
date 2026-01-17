import Foundation

protocol FamilyRepository {
    func fetchFamily() async throws -> Family
}
