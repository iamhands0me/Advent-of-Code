import Foundation

let puzzle = """
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
"""

let puzzles = puzzle.components(separatedBy: "\n\n")
let towels = Set(puzzles[0].components(separatedBy: ", "))
let designs = puzzles[1].components(separatedBy: .newlines)

var arrangementCountsByDesign: [String: Int] = [:]

// Part 1
let possibleDesignCount = designs
    .map(arrangementCount)
    .filter { $0 > 0 }
    .count

// Part 2
let totalArrangementCount = designs
    .map(arrangementCount)
    .reduce(into: 0, +=)

func arrangementCount(of design: String) -> Int {
    guard !design.isEmpty else { return 1 }
    
    if let count = arrangementCountsByDesign[design] {
        return count
    }
    
    let count = design
        .indices
        .filter { towels.contains(String(design[$0...])) }
        .map { arrangementCount(of: String(design[..<$0])) }
        .reduce(into: 0, +=)
        
    arrangementCountsByDesign[design] = count
    return count
}
