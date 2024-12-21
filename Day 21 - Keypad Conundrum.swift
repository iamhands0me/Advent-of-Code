import Algorithms
import Foundation

let puzzle = """
029A
980A
179A
456A
379A
"""

let sequences: [Character: [Character: String]] = [
    ">": ["^": "<^A", "A": "^A", "v": "<A", "<": "<<A"],
    "^": ["A": ">A", ">": "v>A", "v": "vA", "<": "v<A"],
    "v": ["A": "^>A", ">": ">A", "^": "^A", "<": "<A"],
    "<": ["v": ">A", ">": ">>A", "^": ">^A", "A": ">>^A"],
    "A": ["^": "<A", ">": "vA", "v": "<vA", "<": "v<<A",
          "0": "<A", "1": "^<<A", "2": "<^A", "3": "^A", "4": "^^<<A",
          "5": "<^^A", "6": "^^A", "7": "^^^<<A", "8": "^^^<A", "9": "^^^A"],
    "0": ["A": ">A", "1": "^<A", "2": "^A", "3": "^>A", "4": "^^<A",
          "5": "^^A", "6": "^^>A", "7": "^^^<A", "8": "^^^A", "9": "^^^>A"],
    "1": ["A": ">>vA", "0": ">vA", "2": ">A", "3": ">>A", "4": "^A",
          "5": "^>A", "6": "^>>A", "7": "^^A", "8": "^^>A", "9": "^^>>A"],
    "2": ["A": "v>A", "0": "vA", "1": "<A", "3": ">A", "4": "<^A",
          "5": "^A", "6": "^>A", "7": "<^^A", "8": "^^A", "9": "^^>A"],
    "3": ["A": "vA", "0": "<vA", "1": "<<A", "2": "<A", "4": "<<^A",
          "5": "<^A", "6": "^A", "7": "<<^^A", "8": "<^^A", "9": "^^A"],
    "4": ["A": ">>vvA", "0": ">vvA", "1": "vA", "2": "v>A", "3": "v>>A",
          "5": ">A", "6": ">>A", "7": "^A", "8": "^>A", "9": "^>>A"],
    "5": ["A": "vv>A", "0": "vvA", "1": "<vA", "2": "vA", "3": "v>A",
          "4": "<A", "6": ">A", "7": "<^A", "8": "^A", "9": "^>A"],
    "6": ["A": "vvA", "0": "<vvA", "1": "<<vA", "2": "<vA", "3": "vA",
          "4": "<<A", "5": "<A", "7": "<<^A", "8": "<^A", "9": "^A"],
    "7": ["A": ">>vvvA", "0": ">vvvA", "1": "vvA", "2": "vv>A", "3": "vv>>A",
          "4": "vA", "5": "v>A", "6": "v>>A", "8": ">A", "9": ">>A"],
    "8": ["A": "vvv>A", "0": "vvvA", "1": "<vvA", "2": "vvA", "3": "vv>A",
          "4": "<vA", "5": "vA", "6": "v>A", "7": "<A", "9": ">A"],
    "9": ["A": "vvvA", "0": "<vvvA", "1": "<<vvA", "2": "<vvA", "3": "vvA",
          "4": "<<vA", "5": "<vA", "6": "vA", "7": "<<A", "8": "<A"],
]

var counts: [String: Int] = [:]

var sum = 0

for code in puzzle.components(separatedBy: .newlines) {
    let length = ("A" + code)
        .adjacentPairs()
        .map {
            buttonPressCount(of: 26, from: $0.0, to: $0.1)
        }
        .reduce(into: 0, +=)

    let num = Int(String(code.dropLast())) ?? 0
    
    let complexity = length * num
    sum += complexity
}

func buttonPressCount(of robot: Int,
                      from button1: Character,
                      to button2: Character) -> Int {
    guard button1 != button2, robot > 0 else { return 1 }
    
    if let count = counts["\(robot)\(button1)\(button2)"] {
        return count
    }
    
    let count = ("A" + (sequences[button1]?[button2] ?? ""))
        .adjacentPairs()
        .map {
            buttonPressCount(of: robot - 1, from: $0.0, to: $0.1)
        }
        .reduce(into: 0, +=)
    
    counts["\(robot)\(button1)\(button2)"] = count
    return count
}
