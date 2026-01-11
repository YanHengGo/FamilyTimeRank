import Foundation

final class RepositoryContainer {
    let familyRepository: FamilyRepository
    let usageRepository: UsageRepository

    init() {
        self.familyRepository = FamilyRepositoryFake()
        self.usageRepository = UsageRepositoryFake()
    }
}
