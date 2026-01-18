import Foundation

protocol UpdateMemberUseCase {
    func execute(
        familyId: String,
        memberId: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) async throws
}

final class UpdateMemberUseCaseImpl: UpdateMemberUseCase {
    private let familyRepository: FamilyRepository

    init(familyRepository: FamilyRepository) {
        self.familyRepository = familyRepository
    }

    func execute(
        familyId: String,
        memberId: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) async throws {
        try await familyRepository.updateMember(
            familyId: familyId,
            memberId: memberId,
            displayName: displayName,
            role: role,
            deviceModel: deviceModel
        )
    }
}
