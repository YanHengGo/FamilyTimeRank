//
//  ContentView.swift
//  FamilyTimeRank
//
//  Created by 厳恒 on 2026/01/04.
//

import SwiftUI

struct ContentView: View {
    let dependencyContainer: DependencyContainer

    var body: some View {
        HomeView(
            viewModel: HomeViewModel(
                getTodayRankingUseCase: dependencyContainer.useCases.getTodayRankingUseCase
            )
        )
    }
}

#Preview {
    ContentView(dependencyContainer: DependencyContainer())
}
