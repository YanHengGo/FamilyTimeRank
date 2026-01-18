import Combine
import Foundation

@MainActor
final class MemberListViewModel: ObservableObject {
    @Published private(set) var state: MemberListState

    private let familyRepository: FamilyRepository
    private let addMemberUseCase: AddMemberUseCase
    private let updateMemberUseCase: UpdateMemberUseCase
    private let deleteMemberUseCase: DeleteMemberUseCase

    private var familyId: String?

    init(
        familyRepository: FamilyRepository,
        addMemberUseCase: AddMemberUseCase,
        updateMemberUseCase: UpdateMemberUseCase,
        deleteMemberUseCase: DeleteMemberUseCase
    ) {
        self.familyRepository = familyRepository
        self.addMemberUseCase = addMemberUseCase
        self.updateMemberUseCase = updateMemberUseCase
        self.deleteMemberUseCase = deleteMemberUseCase
        self.state = MemberListState(
            status: .idle,
            familyName: "",
            members: []
        )
    }

    func onAppear() {
        guard state.status != .loading else { return }
        state.status = .loading
        Task { await load() }
    }

    func reload() {
        state.status = .loading
        Task { await load() }
    }

    func addMember(displayName: String, role: MemberRole, deviceModel: String) {
        guard let familyId else {
            notifyFamilyIdMissing()
            return
        }
        Task {
            do {
                _ = try await addMemberUseCase.execute(
                    familyId: familyId,
                    displayName: displayName,
                    role: role,
                    deviceModel: deviceModel
                )
                await load()
            } catch {
                state.status = .failed(error.localizedDescription)
            }
        }
    }

    func updateMember(
        memberId: String,
        displayName: String,
        role: MemberRole,
        deviceModel: String
    ) {
        guard let familyId else {
            notifyFamilyIdMissing()
            return
        }
        Task {
            do {
                try await updateMemberUseCase.execute(
                    familyId: familyId,
                    memberId: memberId,
                    displayName: displayName,
                    role: role,
                    deviceModel: deviceModel
                )
                await load()
            } catch {
                state.status = .failed(error.localizedDescription)
            }
        }
    }

    func deleteMember(memberId: String) {
        guard let familyId else {
            notifyFamilyIdMissing()
            return
        }
        Task {
            do {
                try await deleteMemberUseCase.execute(
                    familyId: familyId,
                    memberId: memberId
                )
                await load()
            } catch {
                state.status = .failed(error.localizedDescription)
            }
        }
    }

    private func load() async {
        do {
            let family = try await familyRepository.fetchFamily()
            familyId = family.id
            state = MemberListState(
                status: .loaded,
                familyName: family.name,
                members: family.members.map {
                    MemberRow(
                        id: $0.id,
                        displayName: $0.displayName,
                        role: $0.role,
                        deviceModel: $0.deviceModel
                    )
                }
            )
        } catch {
            state = MemberListState(
                status: .failed(error.localizedDescription),
                familyName: "",
                members: []
            )
        }
    }

    var canManageMembers: Bool {
        familyId != nil && state.status != .loading
    }

    func notifyFamilyIdMissing() {
        state.status = .failed("メンバー情報を取得中です。少し待ってから再試行してください。")
    }
}
