//
//  GameState.swift
//  SudokuMaster
//
//  Author: Het Jasani
//  Student ID: 000000
//

import Foundation

struct GameState: Codable {
    var puzzleID: String
    var difficulty: Difficulty
    var initialGrid: [[Int]]
    var currentGrid: [[Int]]
    var notes: [[[Int]]]
    var elapsedSeconds: Int
    var mistakes: Int
    var hintsUsed: Int
    var isPaused: Bool
}
