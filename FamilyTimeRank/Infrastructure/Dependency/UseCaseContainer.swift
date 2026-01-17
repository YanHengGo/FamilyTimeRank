import Foundation

final class UseCaseContainer {
    let getTodayRankingUseCase: GetTodayRankingUseCase
    let createFamilyUseCase: CreateFamilyUseCase
    let joinFamilyUseCase: JoinFamilyUseCase
    let updateMemberUseCase: UpdateMemberUseCase
    let deleteMemberUseCase: DeleteMemberUseCase

    init(repositories: RepositoryContainer, familyIdStore: FamilyIdStore) {
        self.getTodayRankingUseCase = GetTodayRankingUseCaseImpl(
            familyRepository: repositories.familyRepository,
            usageRepository: repositories.usageRepository
        )
        self.createFamilyUseCase = CreateFamilyUseCaseImpl(
            familyRepository: repositories.familyRepository,
            familyIdStore: familyIdStore
        )
        self.joinFamilyUseCase = JoinFamilyUseCaseImpl(
            familyRepository: repositories.familyRepository,
            familyIdStore: familyIdStore
        )
        self.updateMemberUseCase = UpdateMemberUseCaseImpl(
            familyRepository: repositories.familyRepository
        )
        self.deleteMemberUseCase = DeleteMemberUseCaseImpl(
            familyRepository: repositories.familyRepository
        )
    }
}
