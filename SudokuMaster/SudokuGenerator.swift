//
//  ContentView.swift
//  SudokuMaster
//
//  Created by Parv Mehta on 2026-02-06.
 


import Foundation

class SudokuGenerator {
    
    static func generatePuzzle() -> [[String]] {
        
        let puzzle: [[String]] = [
            ["5","","","6","","8","","1",""],
            ["","","9","","4","","5","",""],
            ["","","","","","","","4",""],
            ["3","","","","","2","","",""],
            ["","","","","8","","","",""],
            ["","","1","","","7","","","3"],
            ["","6","","","","","","",""],
            ["","","5","","1","","3","",""],
            ["","","","","","","","","9"]
        ]
        
        return puzzle
    }
}