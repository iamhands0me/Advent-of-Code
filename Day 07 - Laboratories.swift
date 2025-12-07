import Algorithms
import Foundation

let puzzle = """
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
"""

// Part 1
let splitCount: Int = puzzle
    .replacingOccurrences(of: "S", with: "|")
    .components(separatedBy: .newlines)
    .map(Array.init)
    .reductions {
        zip(".\(String($0)).", ".\(String($1)).")
            .map { "\($0.0)\($0.1)" }
            .windows(ofCount: 3)
            .map(Array.init)
            .map {
                if $0[1] == "|^" {
                    "✅"
                } else if $0[1].first == "|" || [$0[0], $0[2]].contains("|^") {
                    "|"
                } else {
                    $0[1].last ?? "."
                }
            }
    }
    .joined()
    .count { $0 == "✅" }

// Part 2
let timelineCount: Int = puzzle
    .components(separatedBy: .newlines)
    .reduce(Array(repeating: 0, count: puzzle.prefix { !$0.isNewline }.count)) {
        Array(
            zip(([0] + $0 + [0]), ".\($1).")
        )
        .windows(ofCount: 3)
        .map {
            $0
                .enumerated()
                .map { (offset: Int, element: (Int, Character)) -> Int in
                    switch (offset, element.1) {
                    case (1, "S"): 1
                    case (1, "."), (0, "^"), (2, "^"): element.0
                    default: 0
                    }
                }
                .reduce(0, +)
        }
    }
    .reduce(0, +)
