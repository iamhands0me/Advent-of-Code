import Foundation

let puzzle = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
"""

// Part 1
let accessibleRollCount: Int = puzzle
    .filter { !$0.isNewline }
    .enumerated()
    .compactMap { $0.element == "@" ? $0.offset : nil }
    .map { [grid = puzzle.components(separatedBy: .newlines).map(Array.init)] offset in
        [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
            .map { (di: Int, dj: Int) -> (Int, Int) in
                (offset / grid.count + di, offset % grid.count + dj)
            }
            .count { (i: Int, j: Int) -> Bool in
                grid.indices ~= i && grid[i].indices ~= j && grid[i][j] == "@"
            }
    }
    .count { $0 < 4 }

// Part 2 (Topological Sort)
let grid: [[Character]] = puzzle
    .components(separatedBy: .newlines)
    .map(Array.init)

var adjacentRollCounts: [[Int]] = grid.map { $0.map { _ in .max } }
var stack: [(Int, Int)] = []

for i in grid.indices {
    for j in grid[i].indices where grid[i][j] == "@" {
        adjacentRollCounts[i][j] = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
            .map {
                (i + $0, j + $1)
            }
            .count { (i: Int, j: Int) -> Bool in
                grid.indices ~= i && grid[i].indices ~= j && grid[i][j] == "@"
            }
        
        if adjacentRollCounts[i][j] < 4 {
            stack.append((i, j))
        }
    }
}

while let (i, j) = stack.popLast() {
    [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
        .map {
            (i + $0, j + $1)
        }
        .filter { (i: Int, j: Int) -> Bool in
            grid.indices ~= i && grid[i].indices ~= j && grid[i][j] == "@"
        }
        .forEach { (i: Int, j: Int) in
            adjacentRollCounts[i][j] -= 1
            
            if adjacentRollCounts[i][j] == 3 {
                stack.append((i, j))
            }
        }
}

let removableRollCount = adjacentRollCounts
    .joined()
    .count { $0 < 4 }
