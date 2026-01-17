import Foundation

final class DependencyContainer {
    let repositories: RepositoryContainer
    let useCases: UseCaseContainer
    let familyIdStore: FamilyIdStore

    init(source: RepositorySource = .fake) {
        self.repositories = RepositoryContainer(source: source)
        self.familyIdStore = UserDefaultsFamilyIdStore()
        self.useCases = UseCaseContainer(
            repositories: repositories,
            familyIdStore: familyIdStore
        )
    }
}
