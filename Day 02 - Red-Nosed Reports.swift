import Algorithms
import Foundation

let puzzle = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""

let reports: [[Int]] = puzzle
    .components(separatedBy: .newlines)
    .map {
        $0.components(separatedBy: .whitespaces).compactMap(Int.init)
    }

// Part 1
let safeCount = reports
    .filter(isSafe)
    .count

// Part 2
let tolerableCount = reports
    .filter { !isSafe($0) }
    .filter { unsafeLevels in
        unsafeLevels.indices
            .map {
                Array(unsafeLevels[..<$0] + unsafeLevels[($0 + 1)...])
            }
            .contains(where: isSafe)
    }
    .count + safeCount

func isSafe(_ levels: [Int]) -> Bool {
    guard levels[0] != levels[1] else { return false }
    
    let isIncreasing = levels[1] > levels[0]
    
    return levels
        .adjacentPairs()
        .map { $0.1 - $0.0 }
        .allSatisfy { diff in
            (isIncreasing ? (1 ... 3) : (-3 ... -1)) ~= diff
        }
}
