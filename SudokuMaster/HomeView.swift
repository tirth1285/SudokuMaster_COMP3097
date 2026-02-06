//
//  HomeView.swift
//  SudokuMaster
//
//  Created by TIRTH RABADIYA on 2026-02-06.
//

import SwiftUI

struct HomeView: View {

    var body: some View {

        NavigationView {
            VStack(spacing: 25) {

                Text("Sudoku Master")
                    .font(.largeTitle)

                NavigationLink("Start Game", destination: DifficultyView())

                NavigationLink("Leaderboard", destination: LeaderboardView())
            }
        }
    }
}
