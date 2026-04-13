//
//  SudokuMasterApp.swift
//  SudokuMaster
//
//  Author: Het Jasani
//  Student ID: 000000
//

import SwiftUI

@main
struct SudokuMasterApp: App {
    @StateObject private var scoreManager = ScoreManager()
    @StateObject private var gameManager = GameManager()

    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(scoreManager)
                .environmentObject(gameManager)
        }
    }
}
