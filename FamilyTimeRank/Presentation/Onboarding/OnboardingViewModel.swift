import Combine
import Foundation

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var state: OnboardingState
    @Published private(set) var didComplete: Bool

    private let createFamilyUseCase: CreateFamilyUseCase
    private let joinFamilyUseCase: JoinFamilyUseCase
    private let findFamilyMembersUseCase: FindFamilyMembersUseCase
    private let familyIdStore: FamilyIdStore

    init(
        createFamilyUseCase: CreateFamilyUseCase,
        joinFamilyUseCase: JoinFamilyUseCase,
        findFamilyMembersUseCase: FindFamilyMembersUseCase,
        familyIdStore: FamilyIdStore
    ) {
        self.createFamilyUseCase = createFamilyUseCase
        self.joinFamilyUseCase = joinFamilyUseCase
        self.findFamilyMembersUseCase = findFamilyMembersUseCase
        self.familyIdStore = familyIdStore
        self.state = OnboardingState(
            mode: .create,
            familyName: "",
            inviteCode: "",
            displayName: "",
            role: .dad,
            deviceModel: DeviceInfo.modelName(),
            status: .idle,
            memberCandidates: [],
            pendingFamilyId: nil,
            isAddingNewMember: false
        )
        self.didComplete = false
    }

    func submit() {
        guard state.status != .loading else { return }
        let validationError = validate()
        if let validationError {
            state.status = .failed(validationError)
            return
        }
        state.status = .loading
        Task { await handleSubmit() }
    }

    func selectExistingMember(memberId: String) {
        guard let familyId = state.pendingFamilyId else {
            state.status = .failed("家族情報が取得できませんでした。再試行してください。")
            return
        }
        familyIdStore.save(familyId: familyId)
        didComplete = true
    }

    func startAddingNewMember() {
        state.isAddingNewMember = true
        state.status = .idle
    }

    func submitNewMember() {
        guard state.status != .loading else { return }
        if normalizedInviteCode().isEmpty {
            state.status = .failed("招待コードを入力してください。")
            return
        }
        if state.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            state.status = .failed("表示名を入力してください。")
            return
        }
        if state.deviceModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            state.status = .failed("端末名を入力してください。")
            return
        }
        state.status = .loading
        Task { await handleNewMemberSubmit() }
    }

    private func validate() -> String? {
        switch state.mode {
        case .create:
            if state.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "表示名を入力してください。"
            }
            if state.deviceModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "端末名を入力してください。"
            }
            if state.familyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "家族名を入力してください。"
            }
        case .join:
            if normalizedInviteCode().isEmpty {
                return "招待コードを入力してください。"
            }
        }
        return nil
    }

    private func handleSubmit() async {
        do {
            switch state.mode {
            case .create:
                _ = try await createFamilyUseCase.execute(
                    familyName: state.familyName,
                    displayName: state.displayName,
                    role: state.role,
                    deviceModel: state.deviceModel
                )
            case .join:
                let inviteCode = normalizedInviteCode()
                let result = try await findFamilyMembersUseCase.execute(inviteCode: inviteCode)
                state.memberCandidates = result.members.map {
                    MemberRow(
                        id: $0.id,
                        displayName: $0.displayName,
                        role: $0.role,
                        deviceModel: $0.deviceModel
                    )
                }
                state.pendingFamilyId = result.familyId
                state.status = .selectingMember
                state.isAddingNewMember = false
                return
            }
            state.status = .idle
            didComplete = true
        } catch {
            state.status = .failed(error.localizedDescription)
        }
    }

    private func handleNewMemberSubmit() async {
        do {
            let inviteCode = normalizedInviteCode()
            _ = try await joinFamilyUseCase.execute(
                inviteCode: inviteCode,
                displayName: state.displayName,
                role: state.role,
                deviceModel: state.deviceModel
            )
            state.status = .idle
            didComplete = true
        } catch {
            state.status = .failed(error.localizedDescription)
        }
    }

    private func normalizedInviteCode() -> String {
        state.inviteCode
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
    }
}
