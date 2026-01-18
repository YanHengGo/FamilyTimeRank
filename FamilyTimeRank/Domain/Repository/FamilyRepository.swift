import Foundation

protocol FamilyRepository {
    func fetchFamily() async throws -> Family
    func fetchMembers(familyId: String) async throws -> [Member]
    func createFamily(name: String, inviteCode: String) async throws -> String
    func findFamilyId(inviteCode: String) async throws -> String
    func addMember(familyId: String, displayName: String, role: MemberRole) async throws -> String
    func updateMember(
        familyId: String,
        memberId: String,
        displayName: String,
        role: MemberRole
    ) async throws
    func deleteMember(familyId: String, memberId: String) async throws
}

enum FamilyRepositoryError: Error {
    case familyNotFound
    case inviteCodeNotFound
    case memberNotFound
}
