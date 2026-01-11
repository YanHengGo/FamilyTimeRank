import Foundation

struct RankingEntry: Identifiable, Equatable {
    let id: String
    let member: Member
    let minutes: Int
    let rank: Int
}
