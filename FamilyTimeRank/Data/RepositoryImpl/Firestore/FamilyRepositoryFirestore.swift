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

        let domainMembers = members.map { dto in
            let role = MemberRole(rawValue: dto.role) ?? .dad
            return Member(id: dto.id, displayName: dto.displayName, role: role)
        }

        return Family(
            id: familyId,
            name: family.name ?? "Family",
            inviteCode: family.inviteCode ?? "",
            members: domainMembers
        )
    }
}
