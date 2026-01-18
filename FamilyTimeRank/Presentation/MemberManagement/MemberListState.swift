import Foundation

enum MemberListStatus: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}

struct MemberRow: Identifiable, Equatable {
    let id: String
    let displayName: String
    let role: MemberRole
    let deviceModel: String?
}

struct MemberListState: Equatable {
    var status: MemberListStatus
    var familyName: String
    var members: [MemberRow]
}
