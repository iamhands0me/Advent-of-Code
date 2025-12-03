import Algorithms
import Foundation

let puzzle = """
987654321111111
811111111111119
234234234234278
818181911112111
"""

// Part 1
let joltageSum: Int = puzzle
    .components(separatedBy: .newlines)
    .map { $0.compactMap(\.wholeNumberValue) }
    .compactMap { (batteries: [Int]) -> Int? in
        batteries
            .combinations(ofCount: 2)
            .map { $0[0] * 10 + $0[1] }
            .max()
    }
    .reduce(0, +)

// Part 2
let largerJoltageSum: Int = puzzle
    .components(separatedBy: .newlines)
    .map { $0.compactMap(\.wholeNumberValue) }
    .compactMap { (batteries: [Int]) -> Int? in
        batteries
            .reduce(Array(repeating: 0, count: 13)) { maxJoltages, battery in
                zip(
                    maxJoltages,
                    [0] + maxJoltages.map { $0 * 10 + battery }
                )
                .map(max)
            }
            .last
    }
    .reduce(0, +)
