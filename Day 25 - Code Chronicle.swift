import Algorithms
import Foundation

let puzzle = """
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
"""

let schematics = puzzle
    .components(separatedBy: "\n\n")
    .map {
        $0.components(separatedBy: .newlines).map(Array.init)
    }

var lockHeights: [[Int]] = []
var keysHeights: [[Int]] = []

for schematic in schematics {
    var heights: [Int] = []
    for col in 0 ..< 5 {
        let height = (1 ... 5)
            .map { row in schematic[row][col] }
            .filter { $0 == "#" }
            .count

        heights.append(height)
    }

    if schematic[0][0] == "#" {
        lockHeights.append(heights)
    } else  {
        keysHeights.append(heights)
    }
}

// Part 1
let fitCount = product(lockHeights, keysHeights)
    .map(zip)
    .filter { $0.map(+).allSatisfy { $0 <= 5 } }
    .count
