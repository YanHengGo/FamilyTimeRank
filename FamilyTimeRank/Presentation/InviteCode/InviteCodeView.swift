import SwiftUI

struct InviteCodeView: View {
    @StateObject private var viewModel: InviteCodeViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: InviteCodeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("招待コード")
                .font(.title2)

            if viewModel.state.status == .loading {
                ProgressView()
            } else if case let .failed(message) = viewModel.state.status {
                Text(message)
                    .foregroundStyle(.red)
            } else {
                Text(viewModel.state.familyName)
                    .font(.headline)
                Text(viewModel.state.inviteCode)
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .padding(.vertical, 8)

                Button("コピー") {
                    UIPasteboard.general.string = viewModel.state.inviteCode
                }
            }

            Spacer()

            Button("閉じる") {
                dismiss()
            }
        }
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    let repositories = RepositoryContainer(source: .fake)
    let viewModel = InviteCodeViewModel(familyRepository: repositories.familyRepository)
    InviteCodeView(viewModel: viewModel)
}
