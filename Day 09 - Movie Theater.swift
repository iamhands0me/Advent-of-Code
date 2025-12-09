import Algorithms
import Foundation

let puzzle = """
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
"""

// Part1
let maxArea: Int = puzzle
    .components(separatedBy: .newlines)
    .map { (tile: String) -> [Int] in
        tile
            .components(separatedBy: ",")
            .compactMap(Int.init)
    }
    .combinations(ofCount: 2)
    .map {
        (abs($0[0][0] - $0[1][0]) + 1) * (abs($0[0][1] - $0[1][1]) + 1)
    }
    .max() ?? 0

// Part 2
let positions: [[Int]] = puzzle
    .components(separatedBy: .newlines)
    .map {
        $0
            .components(separatedBy: ",")
            .compactMap(Int.init)
    }

var yIndicesByX: [Int: [Int]] = [:]

var xIndicesByY: [Int: [Int]] = [:]

for (p1, p2) in (positions + [positions[0]]).adjacentPairs() {
    if p1[0] == p2[0] {
        for y in min(p1[1], p2[1]) ... max(p1[1], p2[1]) {
            xIndicesByY[y, default: []].append(p1[0])
        }
    } else if p1[1] == p2[1] {
        for x in min(p1[0], p2[0]) ... max(p1[0], p2[0]) {
            yIndicesByX[x, default: []].append(p1[1])
        }
    }
}

yIndicesByX = yIndicesByX.mapValues { $0.sorted() }
xIndicesByY = xIndicesByY.mapValues { $0.sorted() }

var maxLimitedArea = 0
outer: for combo in positions.combinations(ofCount: 2) {
    for x in (min(combo[0][0], combo[1][0]) ... max(combo[0][0], combo[1][0])).dropFirst().dropLast() {
        let yIndices = yIndicesByX[x] ?? []
        let minY = min(combo[0][1], combo[1][1])
        let maxY = max(combo[0][1], combo[1][1])
        
        let index = yIndices.partitioningIndex { $0 > minY }
        guard index > 0, yIndices[index - 1] <= minY, index < yIndices.count, yIndices[index] >= maxY else {
            continue outer
        }
    }
    
    for y in (min(combo[0][1], combo[1][1]) ... max(combo[0][1], combo[1][1])).dropFirst().dropLast() {
        let xIndices = xIndicesByY[y] ?? []
        let minX = min(combo[0][0], combo[1][0])
        let maxX = max(combo[0][0], combo[1][0])
        
        let index = xIndices.partitioningIndex { $0 > minX }
        
        guard index > 0, xIndices[index - 1] <= minX, index < xIndices.count, xIndices[index] >= maxX else {
            continue outer
        }
    }
    
    maxLimitedArea = max(maxLimitedArea, (abs(combo[0][0] - combo[1][0]) + 1) * (abs(combo[0][1] - combo[1][1]) + 1))
}
