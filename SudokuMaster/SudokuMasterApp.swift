//
//  SudokuMasterApp.swift
//  SudokuMaster
//
//  Created by HET JASANI on 2026-02-06.
//
import SwiftUI

@main
struct SudokuMasterApp: App {
    
    @StateObject var scoreManager = ScoreManager()
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(scoreManager)
        }
    }
}