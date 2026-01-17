import Foundation

enum InviteCodeStatus: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}

struct InviteCodeState: Equatable {
    var status: InviteCodeStatus
    var familyName: String
    var inviteCode: String
}
