import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("今日のランキング")
                .font(.title2)

            if viewModel.state.status == .loading {
                ProgressView()
            } else if case let .failed(message) = viewModel.state.status {
                Text(message)
                    .foregroundStyle(.red)
            } else {
                if let average = viewModel.state.familyAverageMinutes {
                    Text("家族平均 \(average)分")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                ForEach(viewModel.state.rows) { row in
                    RankingRowView(
                        rank: row.rank,
                        displayName: row.displayName,
                        minutes: row.minutes
                    )
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    let repositories = RepositoryContainer()
    let useCases = UseCaseContainer(
        repositories: repositories,
        familyIdStore: UserDefaultsFamilyIdStore()
    )
    let viewModel = HomeViewModel(getTodayRankingUseCase: useCases.getTodayRankingUseCase)
    HomeView(viewModel: viewModel)
}
