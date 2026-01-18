import Foundation

protocol JoinFamilyUseCase {
    func execute(
        inviteCode: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) async throws -> String
}

final class JoinFamilyUseCaseImpl: JoinFamilyUseCase {
    private let familyRepository: FamilyRepository
    private let familyIdStore: FamilyIdStore

    init(familyRepository: FamilyRepository, familyIdStore: FamilyIdStore) {
        self.familyRepository = familyRepository
        self.familyIdStore = familyIdStore
    }

    func execute(
        inviteCode: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) async throws -> String {
        let familyId = try await familyRepository.findFamilyId(inviteCode: inviteCode)
        _ = try await familyRepository.addMember(
            familyId: familyId,
            displayName: displayName,
            role: role,
            deviceModel: deviceModel
        )
        familyIdStore.save(familyId: familyId)
        return familyId
    }
}
