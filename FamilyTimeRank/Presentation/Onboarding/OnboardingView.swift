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
                                Text("作成する")
                            }
                        }
                        .disabled(viewModel.state.status == .loading)
                    }
                } else {
                    Section(header: Text("招待コード")) {
                        TextField("招待コード", text: $viewModel.state.inviteCode)
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled(true)
                            .onChange(of: viewModel.state.inviteCode) { value in
                                let uppercased = value.uppercased()
                                if uppercased != value {
                                    viewModel.state.inviteCode = uppercased
                                }
                            }
                    }

                    if viewModel.state.status == .selectingMember {
                        Section(header: Text("メンバー選択")) {
                            if viewModel.state.memberCandidates.isEmpty {
                                Text("該当メンバーがありません。新規メンバーを追加してください。")
                                    .foregroundStyle(.secondary)
                            }
                            ForEach(viewModel.state.memberCandidates) { member in
                                Button {
                                    viewModel.selectExistingMember(memberId: member.id)
                                } label: {
                                    HStack {
                                        Text(member.displayName)
                                        Spacer()
                                        Text(member.roleDisplayName)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        Section {
                            Button("新規メンバーを追加する") {
                                viewModel.startAddingNewMember()
                            }
                        }
                    } else if viewModel.state.isAddingNewMember {
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
                            Button(action: viewModel.submitNewMember) {
                                if viewModel.state.status == .loading {
                                    ProgressView()
                                } else {
                                    Text("参加する")
                                }
                            }
                            .disabled(viewModel.state.status == .loading)
                        }
                        Section {
                            Button("メンバー一覧に戻る") {
                                viewModel.state.status = .selectingMember
                                viewModel.state.isAddingNewMember = false
                            }
                        }
                    } else {
                        Section {
                            Button(action: viewModel.submit) {
                                if viewModel.state.status == .loading {
                                    ProgressView()
                                } else {
                                    Text("メンバー一覧を見る")
                                }
                            }
                            .disabled(viewModel.state.status == .loading)
                        }
                    }
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

private extension MemberRow {
    var roleDisplayName: String {
        switch role {
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
        joinFamilyUseCase: useCases.joinFamilyUseCase,
        findFamilyMembersUseCase: useCases.findFamilyMembersUseCase,
        familyIdStore: UserDefaultsFamilyIdStore()
    )
    OnboardingView(viewModel: viewModel, onComplete: {})
}
