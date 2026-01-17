import Combine
import Foundation

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var state: OnboardingState
    @Published private(set) var didComplete: Bool

    private let createFamilyUseCase: CreateFamilyUseCase
    private let joinFamilyUseCase: JoinFamilyUseCase

    init(
        createFamilyUseCase: CreateFamilyUseCase,
        joinFamilyUseCase: JoinFamilyUseCase
    ) {
        self.createFamilyUseCase = createFamilyUseCase
        self.joinFamilyUseCase = joinFamilyUseCase
        self.state = OnboardingState(
            mode: .create,
            familyName: "",
            inviteCode: "",
            displayName: "",
            role: .dad,
            status: .idle
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

    private func validate() -> String? {
        if state.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "表示名を入力してください。"
        }
        switch state.mode {
        case .create:
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
                    role: state.role
                )
            case .join:
                let inviteCode = normalizedInviteCode()
                _ = try await joinFamilyUseCase.execute(
                    inviteCode: inviteCode,
                    displayName: state.displayName,
                    role: state.role
                )
            }
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
