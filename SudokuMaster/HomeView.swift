//
//  HomeView.swift
//  SudokuMaster
//
//  Author: Tirth Rabadiya
//  Student ID: 000000
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var gameManager: GameManager

    var body: some View {
        VStack(spacing: 24) {
            Text("Sudoku Master")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Choose an option to begin")
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(spacing: 14) {
                NavigationLink(destination: DifficultyView()) {
                    Text("Start New Game")
                }
                .buttonStyle(PrimaryButtonStyle())

                NavigationLink(destination: GameView(startMode: .continueSaved)) {
                    Text("Continue Saved Game")
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!gameManager.hasSavedGame)
                .opacity(gameManager.hasSavedGame ? 1.0 : 0.5)

                NavigationLink(destination: LeaderboardView()) {
                    Text("Leaderboard")
                }
                .buttonStyle(SecondaryButtonStyle())

                NavigationLink(destination: RulesView()) {
                    Text("Rules / How to Play")
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
        .padding(24)
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(GameManager())
    }
}
