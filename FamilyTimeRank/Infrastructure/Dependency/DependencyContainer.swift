import Foundation

final class DependencyContainer {
    let repositories: RepositoryContainer
    let useCases: UseCaseContainer

    init(source: RepositorySource = .fake) {
        self.repositories = RepositoryContainer(source: source)
        self.useCases = UseCaseContainer(repositories: repositories)
    }
}
