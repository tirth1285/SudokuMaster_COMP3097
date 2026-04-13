//
//  SudokuValidator.swift
//  SudokuMaster
//
//  Author: Dhairya Gohel
//  Student ID: 101513410
//

import Foundation

struct SudokuValidator {
    static func isRowValid(grid: [[Int]], row: Int) -> Bool {
        return isSetValid(values: grid[row])
    }

    static func isColumnValid(grid: [[Int]], column: Int) -> Bool {
        let values = (0..<9).map { grid[$0][column] }
        return isSetValid(values: values)
    }

    static func isBoxValid(grid: [[Int]], startRow: Int, startColumn: Int) -> Bool {
        var values: [Int] = []
        for r in 0..<3 {
            for c in 0..<3 {
                values.append(grid[startRow + r][startColumn + c])
            }
        }
        return isSetValid(values: values)
    }

    static func isBoardComplete(grid: [[Int]]) -> Bool {
        for row in 0..<9 {
            if !isRowValid(grid: grid, row: row) {
                return false
            }
        }
        for column in 0..<9 {
            if !isColumnValid(grid: grid, column: column) {
                return false
            }
        }
        for startRow in stride(from: 0, to: 9, by: 3) {
            for startColumn in stride(from: 0, to: 9, by: 3) {
                if !isBoxValid(grid: grid, startRow: startRow, startColumn: startColumn) {
                    return false
                }
            }
        }
        return !grid.flatMap { $0 }.contains(0)
    }

    private static func isSetValid(values: [Int]) -> Bool {
        let filtered = values.filter { $0 != 0 }
        return Set(filtered).count == filtered.count
    }
}
