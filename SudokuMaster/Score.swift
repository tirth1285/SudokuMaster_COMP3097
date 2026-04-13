//
//  Score.swift
//  SudokuMaster
//
//  Author: Tirth Rabadiya
//  Student ID: 000000
//

import Foundation

struct PlayerScore: Identifiable, Codable {
    var id: UUID = UUID()
    var playerName: String
    var difficulty: Difficulty
    var timeSeconds: Int
    var scoreValue: Int
    var date: Date
    var mistakes: Int
    var hintsUsed: Int
}
