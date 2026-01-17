import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    let onComplete: () -> Void

    init(viewModel: OnboardingViewModel, onComplete: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onComplete = onComplete
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("モード")) {
                    Picker("選択", selection: $viewModel.state.mode) {
                        Text("家族を作る").tag(OnboardingMode.create)
                        Text("参加する").tag(OnboardingMode.join)
                    }
                    .pickerStyle(.segmented)
                }

                if viewModel.state.mode == .create {
                    Section(header: Text("家族情報")) {
                        TextField("家族名", text: $viewModel.state.familyName)
                            .textInputAutocapitalization(.never)
                    }
                } else {
                    Section(header: Text("招待コード")) {
                        TextField("招待コード", text: $viewModel.state.inviteCode)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                    }
                }

                Section(header: Text("メンバー情報")) {
                    TextField("表示名", text: $viewModel.state.displayName)
                        .textInputAutocapitalization(.never)
                    Picker("役割", selection: $viewModel.state.role) {
                        ForEach(MemberRole.allCases, id: \.self) { role in
                            Text(role.displayName).tag(role)
                        }
                    }
                }

                Section {
                    Button(action: viewModel.submit) {
                        if viewModel.state.status == .loading {
                            ProgressView()
                        } else {
                            Text(viewModel.state.mode == .create ? "作成する" : "参加する")
                        }
                    }
                    .disabled(viewModel.state.status == .loading)
                }

                if case let .failed(message) = viewModel.state.status {
                    Section {
                        Text(message)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("はじめに")
            .onChange(of: viewModel.didComplete) { completed in
                if completed {
                    onComplete()
                }
            }
        }
    }
}

private extension MemberRole {
    var displayName: String {
        switch self {
        case .dad:
            return "パパ"
        case .mom:
            return "ママ"
        case .son:
            return "息子"
        case .daughter:
            return "娘"
        }
    }
}

#Preview {
    let repositories = RepositoryContainer()
    let useCases = UseCaseContainer(
        repositories: repositories,
        familyIdStore: UserDefaultsFamilyIdStore()
    )
    let viewModel = OnboardingViewModel(
        createFamilyUseCase: useCases.createFamilyUseCase,
        joinFamilyUseCase: useCases.joinFamilyUseCase
    )
    OnboardingView(viewModel: viewModel, onComplete: {})
}
