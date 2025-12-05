import Foundation

let puzzle = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
"""

// Part 1
let freshCount = RangeSet(
    puzzle
        .components(separatedBy: .newlines)
        .prefix { $0.contains("-") }
        .map { ranges in
            ranges
                .components(separatedBy: "-")
                .compactMap(Int.init)
        }
        .map { Range($0[0] ... $0[1]) }
)
.intersection(
    RangeSet(
        IndexSet(
            puzzle
                .components(separatedBy: .newlines)
                .compactMap(Int.init)
        )
    )
)
.ranges
.map(\.count)
.reduce(0, +)

// Part 2
let totalFreshCount = RangeSet(
    puzzle
        .components(separatedBy: .newlines)
        .prefix { $0.contains("-") }
        .map { ranges in
            ranges
                .components(separatedBy: "-")
                .compactMap(Int.init)
        }
        .map { Range($0[0] ... $0[1]) }
)
.ranges
.map(\.count)
.reduce(0, +)
