import Algorithms
import Foundation

let puzzle = """
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
"""

let map: [[Character]] = puzzle
    .components(separatedBy: .newlines)
    .map(Array.init)

var paths: [(i: Int, j: Int)] = []

for i in map.indices {
    for j in map[i].indices {
        if map[i][j] == "S" {
            paths.append((i, j))
        }
    }
}

while let (i, j) = paths.last {
    let nextPosition = [(0, 1), (0, -1), (1, 0), (-1, 0)]
        .map { (i + $0.0, j + $0.1) }
        .filter { map[$0.0][$0.1] != "#" }
        .first { $0 != paths.dropLast().last ?? (-1, -1) }

    guard let nextPosition else { break }

    paths.append(nextPosition)
}

// Part 2
var bestCheatCount = 0

for combo in paths.indexed().combinations(ofCount: 2) {
    let (t1, (i1, j1)) = combo[0]
    let (t2, (i2, j2)) = combo[1]
    let cheatTime = abs(i1 - i2) + abs(j1 - j2)
    let saveTime = t2 - t1 - cheatTime

    if cheatTime <= 20, saveTime >= 100 {
        bestCheatCount += 1
    }
}
