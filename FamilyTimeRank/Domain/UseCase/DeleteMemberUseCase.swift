import Foundation

protocol DeleteMemberUseCase {
    func execute(familyId: String, memberId: String) async throws
}

final class DeleteMemberUseCaseImpl: DeleteMemberUseCase {
    private let familyRepository: FamilyRepository

    init(familyRepository: FamilyRepository) {
        self.familyRepository = familyRepository
    }

    func execute(familyId: String, memberId: String) async throws {
        try await familyRepository.deleteMember(familyId: familyId, memberId: memberId)
    }
}
