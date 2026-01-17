import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var isInviteCodePresented = false
    private let inviteCodeViewModel: InviteCodeViewModel

    init(viewModel: HomeViewModel, inviteCodeViewModel: InviteCodeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.inviteCodeViewModel = inviteCodeViewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("今日のランキング")
                    .font(.title2)
                Spacer()
                Button("招待コード") {
                    isInviteCodePresented = true
                }
                .font(.subheadline)
            }

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
        .sheet(isPresented: $isInviteCodePresented) {
            InviteCodeView(viewModel: inviteCodeViewModel)
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
    let inviteViewModel = InviteCodeViewModel(familyRepository: repositories.familyRepository)
    HomeView(viewModel: viewModel, inviteCodeViewModel: inviteViewModel)
}
