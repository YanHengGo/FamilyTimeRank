import FirebaseFirestore
import Foundation

struct FamilyDTO {
    let name: String?
    let inviteCode: String?
}

struct MemberDTO {
    let id: String
    let displayName: String
    let role: String
}

final class FirestoreFamilyDataSource {
    private let db: Firestore

    init(db: Firestore) {
        self.db = db
    }

    func fetchFamily(
        familyId: String
    ) async throws -> FamilyDTO {
        try await withCheckedThrowingContinuation { continuation in
            db.collection("families")
                .document(familyId)
                .getDocument { snapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let data = snapshot?.data() ?? [:]
                    let name = data["name"] as? String
                    let inviteCode = data["inviteCode"] as? String
                    continuation.resume(returning: FamilyDTO(name: name, inviteCode: inviteCode))
                }
        }
    }

    func fetchMembers(
        familyId: String
    ) async throws -> [MemberDTO] {
        try await withCheckedThrowingContinuation { continuation in
            db.collection("families")
                .document(familyId)
                .collection("members")
                .getDocuments { snapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let members = snapshot?.documents.compactMap { doc -> MemberDTO? in
                        let data = doc.data()
                        guard
                            let displayName = data["displayName"] as? String,
                            let role = data["role"] as? String
                        else { return nil }
                        return MemberDTO(id: doc.documentID, displayName: displayName, role: role)
                    } ?? []
                    continuation.resume(returning: members)
                }
        }
    }
}
