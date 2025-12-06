import Algorithms
import Foundation

let puzzle = """
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
"""

//Part 1
let grandTotal: Int = puzzle
    .components(separatedBy: .newlines)
    .dropLast()
    .map {
        $0
            .components(separatedBy: .whitespaces)
            .compactMap(Int.init)
    }
    .reductions { [symbols = puzzle.filter { "+*".contains($0) }] in
        zip(symbols, zip($0, $1))
            .map {
                $0 == "+" ? $1.0 + $1.1 : $1.0 * $1.1
            }
    }
    .last?.reduce(0, +) ?? 0

// Part 2
let rightGrandTotal: Int = puzzle
    .components(separatedBy: .newlines)
    .dropLast()
    .map {
        Array($0)
            .map(\.wholeNumberValue)
    }
    .reductions {
        zip($0, $1)
            .map {
                $1 != nil ? ($0 ?? 0) * 10 + ($1 ?? 0) : $0
            }
    }
    .last
    .map { (nums: [Int?]) -> Int in
        zip(
            nums.split(separator: nil),
            puzzle.filter { "+*".contains($0) },
        )
        .compactMap {
            $0
                .compacted()
                .reductions($1 == "+" ? (+) : (*))
                .last
        }
        .reduce(0, +)
    } ?? 0
