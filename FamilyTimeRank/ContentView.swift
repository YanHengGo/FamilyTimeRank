//
//  ContentView.swift
//  FamilyTimeRank
//
//  Created by 厳恒 on 2026/01/04.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("familyId") private var familyId: String = ""

    var body: some View {
        if familyId.isEmpty {
            onboardingView()
        } else {
            homeView(familyId: familyId)
        }
    }

    private func onboardingView() -> some View {
        let repositories = RepositoryContainer(source: .firestore(familyId: ""))
        let useCases = UseCaseContainer(
            repositories: repositories,
            familyIdStore: UserDefaultsFamilyIdStore()
        )
        let viewModel = OnboardingViewModel(
            createFamilyUseCase: useCases.createFamilyUseCase,
            joinFamilyUseCase: useCases.joinFamilyUseCase
        )
        return OnboardingView(viewModel: viewModel) {
            familyId = UserDefaultsFamilyIdStore().get() ?? ""
        }
    }

    private func homeView(familyId: String) -> some View {
        let repositories = RepositoryContainer(source: .firestore(familyId: familyId))
        let useCases = UseCaseContainer(
            repositories: repositories,
            familyIdStore: UserDefaultsFamilyIdStore()
        )
        let inviteViewModel = InviteCodeViewModel(
            familyRepository: repositories.familyRepository
        )
        let memberListViewModel = MemberListViewModel(
            familyRepository: repositories.familyRepository,
            addMemberUseCase: useCases.addMemberUseCase,
            updateMemberUseCase: useCases.updateMemberUseCase,
            deleteMemberUseCase: useCases.deleteMemberUseCase
        )
        return HomeView(
            viewModel: HomeViewModel(
                getTodayRankingUseCase: useCases.getTodayRankingUseCase
            ),
            inviteCodeViewModel: inviteViewModel,
            memberListViewModel: memberListViewModel
        )
    }
}

#Preview {
    ContentView()
}
