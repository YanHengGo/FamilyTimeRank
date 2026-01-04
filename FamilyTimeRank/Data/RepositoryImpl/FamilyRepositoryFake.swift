import Foundation

final class FamilyRepositoryFake: FamilyRepository {
    func fetchFamily() -> Family {
        return Family(
            id: "family-001",
            name: "サンプル家族",
            inviteCode: "INVITE123",
            members: [
                Member(id: "member-dad", displayName: "パパ", role: .dad),
                Member(id: "member-mom", displayName: "ママ", role: .mom),
                Member(id: "member-son", displayName: "息子", role: .son),
                Member(id: "member-daughter", displayName: "娘", role: .daughter)
            ]
        )
    }
}
