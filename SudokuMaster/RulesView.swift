//
//  RulesView.swift
//  SudokuMaster
//
//  Author: Tirth Rabadiya
//  Student ID: 000000
//

import SwiftUI

struct RulesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Sudoku Rules")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Fill the 9x9 grid so that:")
                Text("1. Each row contains numbers 1 through 9 exactly once.")
                Text("2. Each column contains numbers 1 through 9 exactly once.")
                Text("3. Each 3x3 box contains numbers 1 through 9 exactly once.")

                Divider()

                Text("How to Play in This App")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("- Tap a cell to select it.")
                Text("- Use the number pad to enter numbers 1-9.")
                Text("- Turn on Notes mode to add pencil marks.")
                Text("- Use Erase to clear a cell.")
                Text("- Hints reveal a correct number but reduce your score.")
                Text("- The game ends when all cells match the solution.")
            }
            .padding(24)
        }
        .navigationTitle("Rules")
    }
}

#Preview {
    NavigationStack {
        RulesView()
    }
}
