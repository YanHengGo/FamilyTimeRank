import Combine
import Foundation

protocol AddMemberUseCase {
    func execute(
        familyId: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) async throws -> String
}

final class AddMemberUseCaseImpl: AddMemberUseCase {
    private let familyRepository: FamilyRepository

    init(familyRepository: FamilyRepository) {
        self.familyRepository = familyRepository
    }

    func execute(
        familyId: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) async throws -> String {
        try await familyRepository.addMember(
            familyId: familyId,
            displayName: displayName,
            role: role,
            deviceModel: deviceModel
        )
    }
}
