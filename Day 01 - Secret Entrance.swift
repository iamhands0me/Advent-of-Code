import Algorithms
import Foundation

let puzzle = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"""

// Part 1
let password = puzzle
    .components(separatedBy: .newlines)
    .compactMap { (rotation: String) -> Int? in
        Int(rotation.dropFirst())
            .map {
                $0 * (rotation.first == "L" ? -1 : 1)
            }
    }
    .reductions(50) {
        (($0 + $1) % 100 + 100) % 100
    }
    .count { $0 == 0 }

// Part 2
let newPassword = puzzle
    .components(separatedBy: .newlines)
    .flatMap { (rotation: String) -> [Int] in
        Array(
            repeating: rotation.first == "L" ? -1 : 1,
            count: Int(rotation.dropFirst()) ?? 0
        )
    }
    .reductions(50) {
        ($0 + $1 + 100) % 100
    }
    .count { $0 == 0 }
