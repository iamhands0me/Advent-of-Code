import Algorithms
import Foundation

let puzzle = """
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"""

let map = puzzle
    .components(separatedBy: .newlines)
    .map(Array.init)

var vectorsByAntenna: [Character: [SIMD2<Int>]] = [:]
for i in map.indices {
    for j in map[i].indices where map[i][j] != "." {
        vectorsByAntenna[map[i][j], default: []].append(SIMD2(x: i, y: j))
    }
}

// Part 1
var antinodesWithinDistance: Set<SIMD2<Int>> = []

// Part 2
var antinodes: Set<SIMD2<Int>> = []

for vectors in vectorsByAntenna.values {
    for combo in vectors.combinations(ofCount: 2) {
        let distance = combo[1] &- combo[0]
        
        let leftAntinode = combo[0] &- distance
        let rightAntinode = combo[1] &+ distance
        antinodesWithinDistance.formUnion(
            [leftAntinode, rightAntinode].filter {
                map.indices ~= $0.x && map[$0.x].indices ~= $0.y
            }
        )
        
        for dir in [-1, 1] {
            var antinode = combo[0]
            
            while map.indices ~= antinode.x,
                  map[antinode.x].indices ~= antinode.y {
                antinodes.insert(antinode)
                
                antinode &+= distance &* dir
            }
        }
    }
}
