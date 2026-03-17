//
//  ScoreManager.swift
//  SudokuMaster
//
//  Created by TIRTH RABADIYA on 2026-03-14.
//
import Foundation
import Combine

class ScoreManager: ObservableObject {
    
    @Published var scores: [Score] = []
    
    let saveKey = "SudokuScores"
    
    init() {
        loadScores()
    }
    
    func addScore(player: String, difficulty: String, time: Int) {
        let newScore = Score(playerName: player, difficulty: difficulty, time: time)
        scores.append(newScore)
        saveScores()
    }
    
    func saveScores() {
        if let encoded = try? JSONEncoder().encode(scores) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func loadScores() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Score].self, from: savedData) {
                scores = decoded
                return
            }
        }
        scores = []
    }
}
