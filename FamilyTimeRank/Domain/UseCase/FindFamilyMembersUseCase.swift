import Foundation

struct FamilyMembersResult: Equatable {
    let familyId: String
    let members: [Member]
}

protocol FindFamilyMembersUseCase {
    func execute(inviteCode: String) async throws -> FamilyMembersResult
}

final class FindFamilyMembersUseCaseImpl: FindFamilyMembersUseCase {
    private let familyRepository: FamilyRepository

    init(familyRepository: FamilyRepository) {
        self.familyRepository = familyRepository
    }

    func execute(inviteCode: String) async throws -> FamilyMembersResult {
        let familyId = try await familyRepository.findFamilyId(inviteCode: inviteCode)
        let members = try await familyRepository.fetchMembers(familyId: familyId)
        return FamilyMembersResult(familyId: familyId, members: members)
    }
}
