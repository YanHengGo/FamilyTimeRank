import Foundation

final class HomeViewModel: ObservableObject {
    @Published private(set) var state: HomeState
    private let getTodayRankingUseCase: GetTodayRankingUseCase

    init(getTodayRankingUseCase: GetTodayRankingUseCase) {
        self.getTodayRankingUseCase = getTodayRankingUseCase
        self.state = HomeState(status: .idle, date: nil, rows: [], familyAverageMinutes: nil)
    }

    func onAppear() {
        guard state.status != .loading else { return }
        state.status = .loading

        let today = Date()
        let result = getTodayRankingUseCase.execute(for: today)

        state = HomeState(
            status: .loaded,
            date: result.ranking.date,
            rows: result.ranking.entries.map {
                HomeRankingRow(
                    id: $0.id,
                    displayName: $0.member.displayName,
                    minutes: $0.minutes,
                    rank: $0.rank
                )
            },
            familyAverageMinutes: result.familyAverageMinutes
        )
    }
}
