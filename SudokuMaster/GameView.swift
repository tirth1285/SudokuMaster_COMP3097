//
//  SudokuMasterApp.swift
//  SudokuMaster
//
//  Created by TIRTH RABADIYA on 2026-02-06.
//

import SwiftUI

struct GameView: View {

    var level: String

    var body: some View {

        VStack(spacing: 20) {

            Text("Difficulty: \(level)")
                .font(.title)

            Text("Sudoku Grid Will Appear Here")
                .padding()

            NavigationLink("View Leaderboard", destination: LeaderboardView())
        }
    }
}
