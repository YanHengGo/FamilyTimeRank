import Foundation

final class FamilyRepositoryFirestore: FamilyRepository {
    private let dataSource: FirestoreFamilyDataSource
    private let familyId: String

    init(
        familyId: String,
        dataSource: FirestoreFamilyDataSource
    ) {
        self.familyId = familyId
        self.dataSource = dataSource
    }

    func fetchFamily() async throws -> Family {
        async let familyDTO = dataSource.fetchFamily(familyId: familyId)
        async let memberDTOs = dataSource.fetchMembers(familyId: familyId)

        let (family, members) = try await (familyDTO, memberDTOs)

        let domainMembers = mapMembers(members)

        return Family(
            id: familyId,
            name: family.name ?? "Family",
            inviteCode: family.inviteCode ?? "",
            members: domainMembers
        )
    }

    func fetchMembers(familyId: String) async throws -> [Member] {
        let members = try await dataSource.fetchMembers(familyId: familyId)
        return mapMembers(members)
    }

    func createFamily(name: String, inviteCode: String) async throws -> String {
        try await dataSource.createFamily(name: name, inviteCode: inviteCode)
    }

    func findFamilyId(inviteCode: String) async throws -> String {
        try await dataSource.findFamilyId(inviteCode: inviteCode)
    }

    func addMember(
        familyId: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) async throws -> String {
        try await dataSource.addMember(
            familyId: familyId,
            displayName: displayName,
            role: role.rawValue,
            deviceModel: deviceModel
        )
    }

    func updateMember(
        familyId: String,
        memberId: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) async throws {
        try await dataSource.updateMember(
            familyId: familyId,
            memberId: memberId,
            displayName: displayName,
            role: role.rawValue,
            deviceModel: deviceModel
        )
    }

    func deleteMember(
        familyId: String,
        memberId: String
    ) async throws {
        try await dataSource.deleteMember(familyId: familyId, memberId: memberId)
    }

    private func mapMembers(_ members: [MemberDTO]) -> [Member] {
        members.map { dto in
            let role = MemberRole(rawValue: dto.role) ?? .dad
            return Member(
                id: dto.id,
                displayName: dto.displayName,
                role: role,
                deviceModel: dto.deviceModel
            )
        }
    }
}
