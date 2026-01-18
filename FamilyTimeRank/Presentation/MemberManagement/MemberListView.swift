import SwiftUI

struct MemberListView: View {
    @StateObject private var viewModel: MemberListViewModel
    @State private var editingMember: MemberRow?
    @State private var deletingMember: MemberRow?

    init(viewModel: MemberListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            if case let .failed(message) = viewModel.state.status {
                Text(message)
                    .foregroundStyle(.red)
            }

            Section(
                header: Text(viewModel.state.familyName.isEmpty ? "メンバー" : viewModel.state.familyName),
                footer: Text("行を左にスワイプで編集・削除")
                    .foregroundStyle(.secondary)
            ) {
                ForEach(viewModel.state.members) { member in
                    HStack {
                        Text(member.displayName)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(member.role.displayName)
                            if let deviceModel = member.deviceModel, !deviceModel.isEmpty {
                                Text(deviceModel)
                                    .font(.caption)
                            }
                        }
                        .foregroundStyle(.secondary)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("編集") {
                            if viewModel.canManageMembers {
                                editingMember = member
                            } else {
                                viewModel.notifyFamilyIdMissing()
                            }
                        }
                        .tint(.blue)
                        Button("削除") {
                            if viewModel.canManageMembers {
                                deletingMember = member
                            } else {
                                viewModel.notifyFamilyIdMissing()
                            }
                        }
                        .tint(.red)
                    }
                }
            }
        }
        .navigationTitle("メンバー管理")
        .onAppear {
            viewModel.onAppear()
        }
        .sheet(item: $editingMember) { member in
            MemberFormView(
                title: "メンバー編集",
                initialDisplayName: member.displayName,
                initialRole: member.role,
                initialDeviceModel: member.deviceModel ?? DeviceInfo.modelName()
            ) { displayName, role, deviceModel in
                viewModel.updateMember(
                    memberId: member.id,
                    displayName: displayName,
                    role: role,
                    deviceModel: deviceModel
                )
            }
        }
        .alert("メンバーを削除しますか？", isPresented: deleteAlertBinding()) {
            Button("削除", role: .destructive) {
                if let member = deletingMember {
                    viewModel.deleteMember(memberId: member.id)
                }
                deletingMember = nil
            }
            Button("キャンセル", role: .cancel) {
                deletingMember = nil
            }
        }
    }

    private func deleteAlertBinding() -> Binding<Bool> {
        Binding(
            get: { deletingMember != nil },
            set: { isPresented in
                if !isPresented {
                    deletingMember = nil
                }
            }
        )
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
    let viewModel = MemberListViewModel(
        familyRepository: repositories.familyRepository,
        addMemberUseCase: useCases.addMemberUseCase,
        updateMemberUseCase: useCases.updateMemberUseCase,
        deleteMemberUseCase: useCases.deleteMemberUseCase
    )
    return NavigationStack {
        MemberListView(viewModel: viewModel)
    }
}
