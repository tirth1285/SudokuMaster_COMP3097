//
//  GameView.swift
//  SudokuMaster
//
//  Author: Tirth Rabadiya
//  Student ID: 000000
//

import SwiftUI

enum GameStartMode {
    case newGame(Difficulty)
    case continueSaved
}

struct GameView: View {
    let startMode: GameStartMode

    @EnvironmentObject private var gameManager: GameManager
    @EnvironmentObject private var scoreManager: ScoreManager
    @Environment(\.dismiss) private var dismiss

    @State private var didStart = false
    @State private var showWinSheet = false
    @State private var showRestartAlert = false
    @State private var showNewGameAlert = false
    @State private var showNoSavedAlert = false
    @State private var playerName = ""

    var body: some View {
        GeometryReader { proxy in
            let boardSize = min(proxy.size.width - 32, 360)
            VStack(spacing: 12) {
                if let state = gameManager.gameState {
                    GameHeaderView(state: state, isPaused: gameManager.isPaused, onPauseToggle: togglePause)

                    if gameManager.invalidMoveFlash {
                        Text("Invalid move")
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    SudokuBoardView(boardSize: boardSize)
                        .environmentObject(gameManager)
                        .padding(.top, 4)
                        .overlay {
                            if gameManager.isPaused {
                                ZStack {
                                    Color.black.opacity(0.4)
                                    Text("Paused")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                        }

                    GameControlsView(
                        isNotesMode: gameManager.isNotesMode,
                        showMistakes: gameManager.showMistakes,
                        onToggleNotes: { gameManager.isNotesMode.toggle() },
                        onToggleMistakes: { gameManager.showMistakes.toggle() },
                        onHint: { gameManager.useHint() },
                        onRestart: { showRestartAlert = true }
                    )

                    NumberPadView(onNumberTap: { number in
                        gameManager.enterNumber(number)
                    }, onErase: {
                        gameManager.eraseCell()
                    })
                    .padding(.bottom, 8)

                    Button("New Game") {
                        showNewGameAlert = true
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .padding(.horizontal, 24)
                } else {
                    ProgressView("Loading...")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 12)
            .navigationTitle("Game")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                startIfNeeded()
            }
            .onChange(of: gameManager.didWin) { _, newValue in
                if newValue {
                    showWinSheet = true
                }
            }
            .onDisappear {
                gameManager.saveProgress()
            }
            .alert("Restart Puzzle?", isPresented: $showRestartAlert) {
                Button("Restart", role: .destructive) {
                    gameManager.restartPuzzle()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will reset the current puzzle and timer.")
            }
            .alert("Start New Game?", isPresented: $showNewGameAlert) {
                Button("Go to Difficulty", role: .destructive) {
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Your current progress will be saved automatically.")
            }
            .alert("No Saved Game", isPresented: $showNoSavedAlert) {
                Button("OK", role: .cancel) { dismiss() }
            } message: {
                Text("There is no saved game to continue.")
            }
            .sheet(isPresented: $showWinSheet) {
                WinSheetView(
                    playerName: $playerName,
                    state: gameManager.gameState,
                    onSave: saveScoreAndDismiss,
                    onPlayAgain: {
                        playerName = ""
                        showWinSheet = false
                        dismiss()
                    }
                )
            }
        }
    }

    private func startIfNeeded() {
        guard !didStart else { return }
        didStart = true
        switch startMode {
        case .newGame(let difficulty):
            gameManager.startNewGame(difficulty: difficulty)
        case .continueSaved:
            if gameManager.hasSavedGame {
                gameManager.loadSavedGame()
            } else {
                showNoSavedAlert = true
            }
        }
    }

    private func togglePause() {
        if gameManager.isPaused {
            gameManager.resumeGame()
        } else {
            gameManager.pauseGame()
        }
    }

    private func saveScoreAndDismiss() {
        guard let state = gameManager.gameState else { return }
        let name = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = name.isEmpty ? "Player" : name
        scoreManager.addScore(
            playerName: finalName,
            difficulty: state.difficulty,
            timeSeconds: state.elapsedSeconds,
            mistakes: state.mistakes,
            hintsUsed: state.hintsUsed
        )
        gameManager.clearSavedGame()
        showWinSheet = false
        dismiss()
    }
}

struct GameHeaderView: View {
    let state: GameState
    let isPaused: Bool
    let onPauseToggle: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            Text("Difficulty: \(state.difficulty.displayName)")
                .font(.headline)
            HStack(spacing: 16) {
                Label("Time \(formattedTime)", systemImage: "timer")
                    .font(.caption)
                Label("Mistakes \(state.mistakes)", systemImage: "xmark.circle")
                    .font(.caption)
                Label("Hints \(state.hintsUsed)", systemImage: "lightbulb")
                    .font(.caption)
            }
            Button(isPaused ? "Resume" : "Pause") {
                onPauseToggle()
            }
            .buttonStyle(SecondaryButtonStyle())
            .padding(.horizontal, 40)
        }
    }

    private var formattedTime: String {
        let minutes = state.elapsedSeconds / 60
        let seconds = state.elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct SudokuBoardView: View {
    @EnvironmentObject private var gameManager: GameManager
    let boardSize: CGFloat

    var body: some View {
        let cellSize = boardSize / 9
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9, id: \.self) { column in
                            SudokuCellView(row: row, column: column, size: cellSize)
                                .environmentObject(gameManager)
                        }
                    }
                }
            }
            .frame(width: boardSize, height: boardSize)
            .background(Color.white)
            .overlay {
                GridLinesView(boardSize: boardSize)
            }
        }
    }
}

struct SudokuCellView: View {
    @EnvironmentObject private var gameManager: GameManager
    let row: Int
    let column: Int
    let size: CGFloat

    private var isSelected: Bool {
        gameManager.selectedRow == row && gameManager.selectedColumn == column
    }

    private var isSameLine: Bool {
        guard let selectedRow = gameManager.selectedRow, let selectedColumn = gameManager.selectedColumn else {
            return false
        }
        return selectedRow == row || selectedColumn == column
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.yellow.opacity(0.5)
        }
        if isSameLine {
            return Color.yellow.opacity(0.2)
        }
        return Color.white
    }

    var body: some View {
        let value = gameManager.gameState?.currentGrid[row][column] ?? 0
        let notes = gameManager.gameState?.notes[row][column] ?? []
        let isGiven = gameManager.isGivenCell(row: row, column: column)
        let isIncorrect = gameManager.showMistakes && gameManager.isCellIncorrect(row: row, column: column)
        let isConflicting = gameManager.showMistakes && gameManager.isCellConflicting(row: row, column: column)

        Button {
            gameManager.selectCell(row: row, column: column)
        } label: {
            ZStack {
                Rectangle()
                    .fill(backgroundColor)

                if value == 0 {
                    NotesGridView(notes: notes)
                } else {
                    Text("\(value)")
                        .font(.system(size: 22, weight: isGiven ? .bold : .regular))
                        .foregroundColor(isGiven ? .black : .blue)
                }
            }
            .frame(width: size, height: size)
            .contentShape(Rectangle())
            .overlay {
                if isIncorrect || isConflicting {
                    Rectangle()
                        .stroke(Color.red, lineWidth: 2)
                } else {
                    Rectangle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(gameManager.isPaused)
    }
}

struct NotesGridView: View {
    let notes: [Int]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(1...9, id: \.self) { number in
                Text(notes.contains(number) ? "\(number)" : "")
                    .font(.system(size: 7))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(2)
    }
}

struct GridLinesView: View {
    let boardSize: CGFloat

    var body: some View {
        let cellSize = boardSize / 9
        ZStack {
            ForEach(0..<10, id: \.self) { index in
                Rectangle()
                    .fill(Color.black)
                    .frame(width: index % 3 == 0 ? 2 : 0.6, height: boardSize)
                    .offset(x: CGFloat(index) * cellSize - boardSize / 2)

                Rectangle()
                    .fill(Color.black)
                    .frame(width: boardSize, height: index % 3 == 0 ? 2 : 0.6)
                    .offset(y: CGFloat(index) * cellSize - boardSize / 2)
            }
        }
        .allowsHitTesting(false)
    }
}

struct GameControlsView: View {
    let isNotesMode: Bool
    let showMistakes: Bool
    let onToggleNotes: () -> Void
    let onToggleMistakes: () -> Void
    let onHint: () -> Void
    let onRestart: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(isNotesMode ? "Notes On" : "Notes Off") {
                onToggleNotes()
            }
            .buttonStyle(SecondaryButtonStyle())

            Button(showMistakes ? "Mistakes On" : "Mistakes Off") {
                onToggleMistakes()
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .padding(.horizontal, 24)

        HStack(spacing: 12) {
            Button("Hint") {
                onHint()
            }
            .buttonStyle(SecondaryButtonStyle())

            Button("Restart") {
                onRestart()
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .padding(.horizontal, 24)
    }
}

struct NumberPadView: View {
    let onNumberTap: (Int) -> Void
    let onErase: () -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(1...9, id: \.self) { number in
                Button("\(number)") {
                    onNumberTap(number)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            Button("Erase") {
                onErase()
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .padding(.horizontal, 24)
    }
}

struct WinSheetView: View {
    @Binding var playerName: String
    let state: GameState?
    let onSave: () -> Void
    let onPlayAgain: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("You solved the puzzle!")
                    .font(.title2)
                    .fontWeight(.bold)

                if let state {
                    Text("Time: \(formatTime(state.elapsedSeconds))")
                    Text("Mistakes: \(state.mistakes) | Hints: \(state.hintsUsed)")
                }

                TextField("Enter your name", text: $playerName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Save Score") {
                    onSave()
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 24)

                Button("Play Again") {
                    onPlayAgain()
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal, 24)

                Spacer()
            }
            .padding(.top, 24)
            .navigationTitle("Winner")
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainder = seconds % 60
        return String(format: "%02d:%02d", minutes, remainder)
    }
}

#Preview {
    NavigationStack {
        GameView(startMode: .newGame(.easy))
            .environmentObject(GameManager())
            .environmentObject(ScoreManager())
    }
}
