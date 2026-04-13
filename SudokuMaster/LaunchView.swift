//
//  LaunchView.swift
//  SudokuMaster
//
//  Author: Tirth Rabadiya
//  Student ID: 000000
//

import SwiftUI

struct LaunchView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            NavigationStack {
                HomeView()
            }
        } else {
            ZStack {
                LinearGradient(colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Sudoku Master")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    VStack(spacing: 6) {
                        Text("Tirth Rabadiya")
                        Text("Dhairya Gohel")
                        Text("Parv Mehta")
                        Text("Het Jasani")
                    }
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    LaunchView()
}
