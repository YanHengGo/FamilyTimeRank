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
    let deviceModel: String
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

    func createFamily(
        name: String,
        inviteCode: String
    ) async throws -> String {
        let docRef = db.collection("families").document()
        let data: [String: Any] = [
            "name": name,
            "inviteCode": inviteCode,
            "createdAt": FieldValue.serverTimestamp()
        ]
        return try await withCheckedThrowingContinuation { continuation in
            docRef.setData(data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: docRef.documentID)
            }
        }
    }

    func findFamilyId(
        inviteCode: String
    ) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            db.collection("families")
                .whereField("inviteCode", isEqualTo: inviteCode)
                .limit(to: 1)
                .getDocuments { snapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let doc = snapshot?.documents.first else {
                        continuation.resume(throwing: FamilyRepositoryError.inviteCodeNotFound)
                        return
                    }
                    continuation.resume(returning: doc.documentID)
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
                        let deviceModel = data["deviceModel"] as? String ?? ""
                        return MemberDTO(
                            id: doc.documentID,
                            displayName: displayName,
                            role: role,
                            deviceModel: deviceModel
                        )
                    } ?? []
                    continuation.resume(returning: members)
                }
        }
    }

    func addMember(
        familyId: String,
        displayName: String,
        role: String,
        deviceModel: String
    ) async throws -> String {
        let docRef = db.collection("families")
            .document(familyId)
            .collection("members")
            .document()
        let data: [String: Any] = [
            "displayName": displayName,
            "role": role,
            "deviceModel": deviceModel,
            "createdAt": FieldValue.serverTimestamp()
        ]
        return try await withCheckedThrowingContinuation { continuation in
            docRef.setData(data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: docRef.documentID)
            }
        }
    }

    func updateMember(
        familyId: String,
        memberId: String,
        displayName: String,
        role: String,
        deviceModel: String
    ) async throws {
        let docRef = db.collection("families")
            .document(familyId)
            .collection("members")
            .document(memberId)
        let data: [String: Any] = [
            "displayName": displayName,
            "role": role,
            "deviceModel": deviceModel,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            docRef.updateData(data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: ())
            }
        }
    }

    func deleteMember(
        familyId: String,
        memberId: String
    ) async throws {
        let docRef = db.collection("families")
            .document(familyId)
            .collection("members")
            .document(memberId)
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            docRef.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: ())
            }
        }
    }
}
