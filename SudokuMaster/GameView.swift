//
//  SudokuMasterApp.swift
//  SudokuMaster
//
//  Created by Parv Mehta on 2026-02-06.
//

import SwiftUI

struct GameView: View {
    
    var level: String
    
    @EnvironmentObject var scoreManager: ScoreManager
    
    @State private var grid = SudokuGenerator.generatePuzzle()
    
    @State private var timeElapsed = 0
    @State private var timer: Timer?
    
    @State private var playerName = ""
    @State private var showSaveAlert = false
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                Text("Difficulty: \(level)")
                    .font(.title)
                
                Text("Time: \(timeElapsed) seconds")
                    .font(.headline)
                
                sudokuGrid
                
                TextField("Enter Player Name", text: $playerName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Button("Check Puzzle") {
                    
                    if checkSolution() {
                        showSaveAlert = true
                    } else {
                        print("Puzzle not solved correctly")
                    }
                }
                .padding()
                
                Button("Finish Game") {
                    
                    if checkSolution() {
                        showSaveAlert = true
                    } else {
                        print("Puzzle incorrect")
                    }
                }
                .padding()
                
                NavigationLink("View Leaderboard", destination: LeaderboardView())
                
            }
            .padding()
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
        .alert("Save Score?", isPresented: $showSaveAlert) {
            
            Button("Save") {
                scoreManager.addScore(player: playerName, difficulty: level, time: timeElapsed)
            }
            
            Button("Cancel", role: .cancel) { }
        }
    }
    
    var sudokuGrid: some View {
        
        VStack(spacing: 2) {
            
            ForEach(0..<9, id: \.self) { row in
                
                HStack(spacing: 2) {
                    
                    ForEach(0..<9, id: \.self) { col in
                        
                        TextField("", text: $grid[row][col])
                            .frame(width: 35, height: 35)
                            .border(Color.black)
                            .multilineTextAlignment(.center)
                            .background(grid[row][col].isEmpty ? Color.white : Color.gray.opacity(0.3))
                    }
                }
            }
        }
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeElapsed += 1
        }
    }
    
    func checkSolution() -> Bool {
        
        for row in grid {
            
            let numbers = row.compactMap { Int($0) }
            
            if Set(numbers).count != 9 {
                return false
            }
        }
        
        return true
    }
}
