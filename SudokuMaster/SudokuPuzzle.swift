//
//  SudokuPuzzle.swift
//  SudokuMaster
//
//  Author: Dhairya Gohel
//  Student ID: 101513410
//

import Foundation

struct SudokuPuzzle: Identifiable {
    let id: String
    let difficulty: Difficulty
    let puzzle: [[Int]]
    let solution: [[Int]]
}
