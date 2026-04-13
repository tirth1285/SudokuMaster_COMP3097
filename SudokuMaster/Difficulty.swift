//
//  Difficulty.swift
//  SudokuMaster
//
//  Author: Tirth Rabadiya
//  Student ID: 000000
//

import Foundation

enum Difficulty: String, CaseIterable, Codable, Identifiable {
    case easy
    case medium
    case hard

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }

    var baseScore: Int {
        switch self {
        case .easy:
            return 1000
        case .medium:
            return 2000
        case .hard:
            return 3000
        }
    }
}
