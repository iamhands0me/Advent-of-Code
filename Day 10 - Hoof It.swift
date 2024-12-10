import Foundation

let puzzle = """
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
"""

let map = puzzle
    .components(separatedBy: .newlines)
    .map {
        $0.compactMap(\.wholeNumberValue)
    }

// Part 1
var scoreSum = 0

// Part 2
var ratingSum = 0

for i in map.indices {
    for j in map[i].indices where map[i][j] == 0 {
        var nineHeightPositions: [[Int]] = []
        
        getTrails(&nineHeightPositions, in: map, from: i, j)
        
        scoreSum += Set(nineHeightPositions).count
        ratingSum += nineHeightPositions.count
    }
}

func getTrails(_ nineHeightPositions: inout [[Int]],
               in map: [[Int]],
               from i: Int, _ j: Int) {
    guard map[i][j] < 9 else {
        nineHeightPositions.append([i, j])
        return
    }
    
    for (ni, nj) in [(1, 0), (-1, 0), (0, 1), (0, -1)].map({ (i + $0.0, j + $0.1) }) {
        guard map.indices ~= ni,
              map[ni].indices ~= nj,
              map[ni][nj] == map[i][j] + 1 else {
            continue
        }
        
        getTrails(&nineHeightPositions, in: map, from: ni, nj)
    }
}
