//
//  ContentView.swift
//  SudokuMaster
//
//  Created by TIRTH RABADIYA on 2026-02-06.
//

import SwiftUI

struct DifficultyView: View {

    var body: some View {

        VStack(spacing: 20) {

            Text("Select Difficulty")
                .font(.title)

            NavigationLink("Easy", destination: GameView(level: "Easy"))
            NavigationLink("Medium", destination: GameView(level: "Medium"))
            NavigationLink("Hard", destination: GameView(level: "Hard"))
        }
    }
}
