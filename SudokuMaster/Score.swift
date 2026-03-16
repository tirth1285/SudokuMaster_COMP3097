//
//  Score.swift
//  SudokuMaster
//
//  Created by TIRTH RABADIYA on 2026-03-14.
//
import Foundation

struct Score: Identifiable, Codable {
    var id = UUID()
    var playerName: String
    var difficulty: String
    var time: Int
}
