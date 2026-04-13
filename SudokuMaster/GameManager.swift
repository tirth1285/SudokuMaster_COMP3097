//
//  GameManager.swift
//  SudokuMaster
//
//  Author: Het Jasani
//  Student ID: 000000
//

import Foundation
import Combine

class GameManager: ObservableObject {
    @Published private(set) var gameState: GameState?
    @Published var selectedRow: Int? = nil
    @Published var selectedColumn: Int? = nil
    @Published var isNotesMode: Bool = false
    @Published var showMistakes: Bool = false
    @Published var didWin: Bool = false
    @Published var isPaused: Bool = false
    @Published var invalidMoveFlash: Bool = false

    private var currentPuzzle: SudokuPuzzle?
    private var timer: Timer?

    var hasSavedGame: Bool {
        GamePersistence.shared.hasSavedGame
    }

    func startNewGame(difficulty: Difficulty) {
        let puzzle = SudokuLibrary.randomPuzzle(for: difficulty)
        currentPuzzle = puzzle
        let emptyNotes = Array(repeating: Array(repeating: [Int](), count: 9), count: 9)
        gameState = GameState(
            puzzleID: puzzle.id,
            difficulty: puzzle.difficulty,
            initialGrid: puzzle.puzzle,
            currentGrid: puzzle.puzzle,
            notes: emptyNotes,
            elapsedSeconds: 0,
            mistakes: 0,
            hintsUsed: 0,
            isPaused: false
        )
        selectedRow = nil
        selectedColumn = nil
        isPaused = false
        didWin = false
        startTimer()
        saveProgress()
    }

    func loadSavedGame() {
        guard let saved = GamePersistence.shared.loadGameState(),
              let puzzle = SudokuLibrary.puzzle(for: saved.puzzleID) else {
            return
        }
        currentPuzzle = puzzle
        gameState = saved
        selectedRow = nil
        selectedColumn = nil
        isPaused = saved.isPaused
        didWin = false
        if !isPaused {
            startTimer()
        }
    }

    func saveProgress() {
        guard let state = gameState else { return }
        GamePersistence.shared.saveGameState(state)
    }

    func clearSavedGame() {
        GamePersistence.shared.clearSavedGame()
    }

    func pauseGame() {
        isPaused = true
        stopTimer()
        updateGameState { state in
            state.isPaused = true
        }
        saveProgress()
    }

    func resumeGame() {
        isPaused = false
        updateGameState { state in
            state.isPaused = false
        }
        startTimer()
    }

    func restartPuzzle() {
        updateGameState { state in
            state.currentGrid = state.initialGrid
            state.notes = Array(repeating: Array(repeating: [Int](), count: 9), count: 9)
            state.elapsedSeconds = 0
            state.mistakes = 0
            state.hintsUsed = 0
            state.isPaused = false
        }
        didWin = false
        isPaused = false
        startTimer()
        saveProgress()
    }

    func selectCell(row: Int, column: Int) {
        selectedRow = row
        selectedColumn = column
    }

    func enterNumber(_ value: Int) {
        guard !isPaused else { return }
        guard let row = selectedRow, let column = selectedColumn else { return }
        guard !isGivenCell(row: row, column: column) else { return }

        if isNotesMode {
            toggleNote(value, row: row, column: column)
            return
        }

        if isMoveValid(value: value, row: row, column: column) {
            updateGameState { state in
                state.currentGrid[row][column] = value
                state.notes[row][column] = []
            }
            checkForWin()
            saveProgress()
        } else {
            registerMistake()
        }
    }

    func eraseCell() {
        guard !isPaused else { return }
        guard let row = selectedRow, let column = selectedColumn else { return }
        guard !isGivenCell(row: row, column: column) else { return }

        updateGameState { state in
            state.currentGrid[row][column] = 0
            state.notes[row][column] = []
        }
        saveProgress()
    }

    func useHint() {
        guard !isPaused else { return }
        guard var state = gameState, let puzzle = currentPuzzle else { return }

        var emptyCells: [(Int, Int)] = []
        for row in 0..<9 {
            for column in 0..<9 {
                if state.currentGrid[row][column] == 0 {
                    emptyCells.append((row, column))
                }
            }
        }

        guard let pick = emptyCells.randomElement() else { return }
        let (row, column) = pick

        state.currentGrid[row][column] = puzzle.solution[row][column]
        state.notes[row][column] = []
        state.hintsUsed += 1
        gameState = state
        checkForWin()
        saveProgress()
    }

    func isGivenCell(row: Int, column: Int) -> Bool {
        guard let state = gameState else { return false }
        return state.initialGrid[row][column] != 0
    }

    func isCellIncorrect(row: Int, column: Int) -> Bool {
        guard let state = gameState else { return false }
        let value = state.currentGrid[row][column]
        guard value != 0 else { return false }
        return isCellConflicting(row: row, column: column)
    }

    func isCellConflicting(row: Int, column: Int) -> Bool {
        guard let state = gameState else { return false }
        let value = state.currentGrid[row][column]
        guard value != 0 else { return false }

        for col in 0..<9 {
            if col != column && state.currentGrid[row][col] == value {
                return true
            }
        }
        for r in 0..<9 {
            if r != row && state.currentGrid[r][column] == value {
                return true
            }
        }
        let boxRow = (row / 3) * 3
        let boxCol = (column / 3) * 3
        for r in boxRow..<(boxRow + 3) {
            for c in boxCol..<(boxCol + 3) {
                if (r != row || c != column) && state.currentGrid[r][c] == value {
                    return true
                }
            }
        }
        return false
    }

    func formattedTime() -> String {
        guard let state = gameState else { return "00:00" }
        let minutes = state.elapsedSeconds / 60
        let seconds = state.elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func toggleNote(_ value: Int, row: Int, column: Int) {
        updateGameState { state in
            if state.notes[row][column].contains(value) {
                state.notes[row][column].removeAll { $0 == value }
            } else {
                state.notes[row][column].append(value)
                state.notes[row][column].sort()
            }
        }
        saveProgress()
    }

    private func isMoveValid(value: Int, row: Int, column: Int) -> Bool {
        guard var state = gameState else { return false }
        state.currentGrid[row][column] = value
        if !SudokuValidator.isRowValid(grid: state.currentGrid, row: row) {
            return false
        }
        if !SudokuValidator.isColumnValid(grid: state.currentGrid, column: column) {
            return false
        }
        let startRow = (row / 3) * 3
        let startColumn = (column / 3) * 3
        return SudokuValidator.isBoxValid(grid: state.currentGrid, startRow: startRow, startColumn: startColumn)
    }

    private func registerMistake() {
        updateGameState { state in
            state.mistakes += 1
        }
        invalidMoveFlash = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.invalidMoveFlash = false
        }
        saveProgress()
    }

    private func checkForWin() {
        guard let state = gameState else { return }
        if SudokuValidator.isBoardComplete(grid: state.currentGrid) {
            didWin = true
            stopTimer()
            GamePersistence.shared.clearSavedGame()
        }
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.updateGameState { state in
                state.elapsedSeconds += 1
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateGameState(_ update: (inout GameState) -> Void) {
        guard var state = gameState else { return }
        update(&state)
        gameState = state
    }
}
