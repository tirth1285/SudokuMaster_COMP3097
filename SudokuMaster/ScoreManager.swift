//
//  ScoreManager.swift
//  SudokuMaster
//
//  Author: Tirth Rabadiya
//  Student ID: 000000
//

import Foundation
import Combine

class ScoreManager: ObservableObject {
    @Published private(set) var scores: [PlayerScore] = []

    private let saveKey = "SudokuScores"

    init() {
        loadScores()
    }

    func addScore(playerName: String, difficulty: Difficulty, timeSeconds: Int, mistakes: Int, hintsUsed: Int) {
        let scoreValue = calculateScore(difficulty: difficulty, timeSeconds: timeSeconds, mistakes: mistakes, hintsUsed: hintsUsed)
        let newScore = PlayerScore(
            playerName: playerName,
            difficulty: difficulty,
            timeSeconds: timeSeconds,
            scoreValue: scoreValue,
            date: Date(),
            mistakes: mistakes,
            hintsUsed: hintsUsed
        )
        scores.append(newScore)
        saveScores()
    }

    func clearScores() {
        scores.removeAll()
        saveScores()
    }

    func sortedScores(for filter: Difficulty?) -> [PlayerScore] {
        let filtered = filter == nil ? scores : scores.filter { $0.difficulty == filter }
        return filtered.sorted { $0.scoreValue > $1.scoreValue }
    }

    private func calculateScore(difficulty: Difficulty, timeSeconds: Int, mistakes: Int, hintsUsed: Int) -> Int {
        let base = difficulty.baseScore
        let timePenalty = max(0, timeSeconds / 2)
        let mistakePenalty = mistakes * 50
        let hintPenalty = hintsUsed * 100
        return max(0, base - timePenalty - mistakePenalty - hintPenalty)
    }

    private func saveScores() {
        if let encoded = try? JSONEncoder().encode(scores) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadScores() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([PlayerScore].self, from: savedData) {
                scores = decoded
                return
            }
        }
        scores = []
    }
}
