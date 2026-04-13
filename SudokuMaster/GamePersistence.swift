//
//  GamePersistence.swift
//  SudokuMaster
//
//  Author: Tirth Rabadiya
//  Student ID: 000000
//

import Foundation

class GamePersistence {
    static let shared = GamePersistence()

    private let saveKey = "SavedSudokuGameState"

    private init() { }

    var hasSavedGame: Bool {
        UserDefaults.standard.data(forKey: saveKey) != nil
    }

    func saveGameState(_ state: GameState) {
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    func loadGameState() -> GameState? {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else {
            return nil
        }
        return try? JSONDecoder().decode(GameState.self, from: data)
    }

    func clearSavedGame() {
        UserDefaults.standard.removeObject(forKey: saveKey)
    }
}
