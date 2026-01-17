import Foundation

enum MemberRole: String, CaseIterable {
    case dad
    case mom
    case son
    case daughter
}

struct Member: Identifiable, Equatable {
    let id: String
    let displayName: String
    let role: MemberRole
}
