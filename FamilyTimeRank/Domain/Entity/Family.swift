import Foundation

struct Family: Identifiable, Equatable {
    let id: String
    let name: String
    let inviteCode: String
    let members: [Member]
}
