//
//  LeaderboardView.swift
//  SudokuMaster
//
//  Author: Tirth Rabadiya
//  Student ID: 000000
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject private var scoreManager: ScoreManager
    @State private var selectedDifficulty: Difficulty? = nil
    @State private var showClearAlert = false

    private var scores: [PlayerScore] {
        scoreManager.sortedScores(for: selectedDifficulty)
    }

    var body: some View {
        VStack(spacing: 12) {
            Picker("Difficulty", selection: $selectedDifficulty) {
                Text("All").tag(Difficulty?.none)
                ForEach(Difficulty.allCases) { difficulty in
                    Text(difficulty.displayName).tag(Difficulty?.some(difficulty))
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if scores.isEmpty {
                Text("No scores yet")
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
            } else {
                List(scores) { score in
                    LeaderboardRow(score: score)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Leaderboard")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Clear") {
                    showClearAlert = true
                }
            }
        }
        .alert("Clear Leaderboard?", isPresented: $showClearAlert) {
            Button("Clear", role: .destructive) {
                scoreManager.clearScores()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will remove all saved scores.")
        }
    }
}

struct LeaderboardRow: View {
    let score: PlayerScore

    private var dateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: score.date)
    }

    private var timeText: String {
        let minutes = score.timeSeconds / 60
        let seconds = score.timeSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(score.playerName)
                    .font(.headline)
                Text("Difficulty: \(score.difficulty.displayName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Date: \(dateText)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("Score: \(score.scoreValue)")
                    .font(.headline)
                Text("Time: \(timeText)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Mistakes: \(score.mistakes), Hints: \(score.hintsUsed)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        LeaderboardView()
            .environmentObject(ScoreManager())
    }
}
