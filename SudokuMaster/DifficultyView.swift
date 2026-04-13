//
//  DifficultyView.swift
//  SudokuMaster
//
//  Author: Tirth Rabadiya
//  Student ID: 000000
//

import SwiftUI

struct DifficultyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Difficulty")
                .font(.title2)
                .fontWeight(.semibold)

            ForEach(Difficulty.allCases) { difficulty in
                NavigationLink(destination: GameView(startMode: .newGame(difficulty))) {
                    Text(difficulty.displayName)
                }
                .buttonStyle(PrimaryButtonStyle())
            }

            Spacer()
        }
        .padding(24)
        .navigationTitle("Difficulty")
    }
}

#Preview {
    NavigationStack {
        DifficultyView()
    }
}
