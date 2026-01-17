import FirebaseFirestore
import Foundation

struct UsageDeviceDTO {
    let memberId: String
    let minutes: Int
}

final class FirestoreUsageDataSource {
    private let db: Firestore

    init(db: Firestore) {
        self.db = db
    }

    func fetchUsageDevices(
        familyId: String,
        dateKey: String
    ) async throws -> [UsageDeviceDTO] {
        try await withCheckedThrowingContinuation { continuation in
            db.collection("families")
                .document(familyId)
                .collection("usagesDaily")
                .document(dateKey)
                .collection("devices")
                .getDocuments { snapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let documents = snapshot?.documents ?? []
                    let items = documents.compactMap { doc -> UsageDeviceDTO? in
                        let data = doc.data()
                        guard let memberId = data["memberId"] as? String else { return nil }
                        let minutesValue = data["minutes"]
                        let minutes: Int?
                        if let intValue = minutesValue as? Int {
                            minutes = intValue
                        } else if let numberValue = minutesValue as? NSNumber {
                            minutes = numberValue.intValue
                        } else {
                            minutes = nil
                        }
                        guard let minutes else { return nil }
                        return UsageDeviceDTO(memberId: memberId, minutes: minutes)
                    } ?? []
                    continuation.resume(returning: items)
                }
        }
    }
}
