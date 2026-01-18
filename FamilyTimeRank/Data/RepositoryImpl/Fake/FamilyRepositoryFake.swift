import Foundation

final class FamilyRepositoryFake: FamilyRepository {
    private var family: Family

    init() {
        self.family = Family(
            id: "family-001",
            name: "サンプル家族",
            inviteCode: "INVITE123",
            members: [
                Member(id: "member-dad", displayName: "パパ", role: .dad, deviceModel: "iPhone 15"),
                Member(id: "member-mom", displayName: "ママ", role: .mom, deviceModel: "iPhone 15"),
                Member(id: "member-son", displayName: "息子", role: .son, deviceModel: "iPad Pro 12.9"),
                Member(id: "member-daughter", displayName: "娘", role: .daughter, deviceModel: "iPad Pro 11")
            ]
        )
    }

    func fetchFamily() async throws -> Family {
        return family
    }

    func fetchMembers(familyId: String) async throws -> [Member] {
        guard family.id == familyId else {
            throw FamilyRepositoryError.familyNotFound
        }
        return family.members
    }

    func createFamily(name: String, inviteCode: String) async throws -> String {
        let newId = "family-\(UUID().uuidString)"
        family = Family(id: newId, name: name, inviteCode: inviteCode, members: [])
        return newId
    }

    func findFamilyId(inviteCode: String) async throws -> String {
        guard family.inviteCode == inviteCode else {
            throw FamilyRepositoryError.inviteCodeNotFound
        }
        return family.id
    }

    func addMember(
        familyId: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) async throws -> String {
        guard family.id == familyId else {
            throw FamilyRepositoryError.familyNotFound
        }
        let newId = "member-\(UUID().uuidString)"
        let member = Member(id: newId, displayName: displayName, role: role, deviceModel: deviceModel)
        family = Family(
            id: family.id,
            name: family.name,
            inviteCode: family.inviteCode,
            members: family.members + [member]
        )
        return newId
    }

    func updateMember(
        familyId: String,
        memberId: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) async throws {
        guard family.id == familyId else {
            throw FamilyRepositoryError.familyNotFound
        }
        guard family.members.contains(where: { $0.id == memberId }) else {
            throw FamilyRepositoryError.memberNotFound
        }
        let updatedMembers = family.members.map { member in
            guard member.id == memberId else { return member }
            return Member(id: memberId, displayName: displayName, role: role, deviceModel: deviceModel)
        }
        family = Family(
            id: family.id,
            name: family.name,
            inviteCode: family.inviteCode,
            members: updatedMembers
        )
    }

    func deleteMember(familyId: String, memberId: String) async throws {
        guard family.id == familyId else {
            throw FamilyRepositoryError.familyNotFound
        }
        guard family.members.contains(where: { $0.id == memberId }) else {
            throw FamilyRepositoryError.memberNotFound
        }
        let updatedMembers = family.members.filter { $0.id != memberId }
        family = Family(
            id: family.id,
            name: family.name,
            inviteCode: family.inviteCode,
            members: updatedMembers
        )
    }
}
