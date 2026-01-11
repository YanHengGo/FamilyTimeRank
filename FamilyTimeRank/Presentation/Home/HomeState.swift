import Foundation

enum HomeStatus: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}

struct HomeRankingRow: Identifiable, Equatable {
    let id: String
    let displayName: String
    let minutes: Int
    let rank: Int
}

struct HomeState: Equatable {
    var status: HomeStatus
    var date: Date?
    var rows: [HomeRankingRow]
    var familyAverageMinutes: Int?
}
