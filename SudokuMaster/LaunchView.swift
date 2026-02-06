//
//  Launch Screen.swift
//  SudokuMaster
//
//  Created by TIRTH RABADIYA on 2026-02-06.
//

import SwiftUI

struct LaunchView: View {

    @State private var isActive = false

    var body: some View {

        if isActive {
            HomeView()
        } else {
            VStack(spacing: 15) {

                Text("Sudoku Master")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Parv Mehta")
                Text("Tirth Rabadiya")
                Text("Het Jasani")
                Text("Dhairya Gohel")
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isActive = true
                }
            }
        }
    }
}
