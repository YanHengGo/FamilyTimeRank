import Combine
import Foundation

enum OnboardingMode: String, CaseIterable, Identifiable {
    case create
    case join

    var id: String { rawValue }
}

enum OnboardingStatus: Equatable {
    case idle
    case loading
    case selectingMember
    case failed(String)
}

struct OnboardingState: Equatable {
    var mode: OnboardingMode
    var familyName: String
    var inviteCode: String
    var displayName: String
    var role: MemberRole
    var status: OnboardingStatus
    var memberCandidates: [MemberRow]
    var pendingFamilyId: String?
    var isAddingNewMember: Bool
}
