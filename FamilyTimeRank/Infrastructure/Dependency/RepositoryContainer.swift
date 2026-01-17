import FirebaseFirestore
import Foundation

enum RepositorySource {
    case fake
    case firestore(familyId: String)
}

final class RepositoryContainer {
    let familyRepository: FamilyRepository
    let usageRepository: UsageRepository

    init(source: RepositorySource = .fake) {
        switch source {
        case .fake:
            self.familyRepository = FamilyRepositoryFake()
            self.usageRepository = UsageRepositoryFake()
        case .firestore(let familyId):
            let db = Firestore.firestore()
            let familyDataSource = FirestoreFamilyDataSource(db: db)
            let usageDataSource = FirestoreUsageDataSource(db: db)
            self.familyRepository = FamilyRepositoryFirestore(
                familyId: familyId,
                dataSource: familyDataSource
            )
            self.usageRepository = UsageRepositoryFirestore(
                familyId: familyId,
                dataSource: usageDataSource
            )
        }
    }
}
