import Combine
import Foundation

@MainActor
final class InviteCodeViewModel: ObservableObject {
    @Published private(set) var state: InviteCodeState

    private let familyRepository: FamilyRepository

    init(familyRepository: FamilyRepository) {
        self.familyRepository = familyRepository
        self.state = InviteCodeState(status: .idle, familyName: "", inviteCode: "")
    }

    func onAppear() {
        guard state.status != .loading else { return }
        state.status = .loading
        Task { await load() }
    }

    private func load() async {
        do {
            let family = try await familyRepository.fetchFamily()
            state = InviteCodeState(
                status: .loaded,
                familyName: family.name,
                inviteCode: family.inviteCode
            )
        } catch {
            state = InviteCodeState(
                status: .failed(error.localizedDescription),
                familyName: "",
                inviteCode: ""
            )
        }
    }
}
