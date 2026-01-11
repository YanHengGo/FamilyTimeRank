import Foundation

final class DependencyContainer {
    let repositories: RepositoryContainer
    let useCases: UseCaseContainer

    init() {
        self.repositories = RepositoryContainer()
        self.useCases = UseCaseContainer(repositories: repositories)
    }
}
