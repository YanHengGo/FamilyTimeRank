import Foundation

protocol CreateFamilyUseCase {
    func execute(
        familyName: String,
        displayName: String,
        role: MemberRole
    ) async throws -> String
}

final class CreateFamilyUseCaseImpl: CreateFamilyUseCase {
    private let familyRepository: FamilyRepository
    private let familyIdStore: FamilyIdStore

    init(familyRepository: FamilyRepository, familyIdStore: FamilyIdStore) {
        self.familyRepository = familyRepository
        self.familyIdStore = familyIdStore
    }

    func execute(
        familyName: String,
        displayName: String,
        role: MemberRole
    ) async throws -> String {
        let inviteCode = Self.generateInviteCode()
        let familyId = try await familyRepository.createFamily(
            name: familyName,
            inviteCode: inviteCode
        )
        _ = try await familyRepository.addMember(
            familyId: familyId,
            displayName: displayName,
            role: role
        )
        familyIdStore.save(familyId: familyId)
        return familyId
    }

    private static func generateInviteCode() -> String {
        let chars = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
        return String((0..<6).compactMap { _ in chars.randomElement() })
    }
}
