import Collections
import Foundation

let puzzle = """
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
"""

let maze: [[Character]] = puzzle
    .components(separatedBy: .newlines)
    .map(Array.init)

var scores: [[[Int]]] = maze.map {
    $0.map { _ in
        Array(repeating: Int.max, count: 4)
    }
}

var heap: Heap<Tile> = []

for i in maze.indices {
    for j in maze[i].indices where maze[i][j] == "S" {
        scores[i][j][0] = 0
        heap.insert(Tile(i: i, j: j, dir: 0, score: 0, path: [[i, j]]))
    }
}

// Part 1
var lowestScore = Int.max

// Part 2
var bestPathIndices: Set<[Int]> = []

while let tile = heap.popMin() {
    guard tile.score <= scores[tile.i][tile.j][tile.dir] else { continue }

    if maze[tile.i][tile.j] == "E", tile.score <= lowestScore {
        if tile.score < lowestScore {
            bestPathIndices = []
        }
        lowestScore = tile.score
        bestPathIndices.formUnion(tile.path)
    }

    for dir in [(0, 1), (0, -1), (1, 0), (-1, 0)].enumerated() {
        let (ni, nj) = (tile.i + dir.element.0, tile.j + dir.element.1)
        let newScore = tile.score + 1 + (tile.dir == dir.offset ? 0 : 1000)

        guard maze[ni][nj] != "#", newScore <= scores[ni][nj][dir.offset] else { continue }

        scores[ni][nj][dir.offset] = newScore
        heap.insert(Tile(i: ni, j: nj, dir: dir.offset, score: newScore, path: tile.path.union([[ni, nj]])))
    }
}

struct Tile: Comparable {
    let i: Int
    let j: Int
    let dir: Int
    let score: Int
    let path: Set<[Int]>

    static func <(lhs: Tile, rhs: Tile) -> Bool {
        lhs.score < rhs.score
    }
}
