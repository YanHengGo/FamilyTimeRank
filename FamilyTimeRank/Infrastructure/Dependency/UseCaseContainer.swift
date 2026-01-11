import Foundation

final class UseCaseContainer {
    let getTodayRankingUseCase: GetTodayRankingUseCase

    init(repositories: RepositoryContainer) {
        self.getTodayRankingUseCase = GetTodayRankingUseCaseImpl(
            familyRepository: repositories.familyRepository,
            usageRepository: repositories.usageRepository
        )
    }
}
