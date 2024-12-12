import Algorithms
import Foundation

let puzzle = """
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
"""

let map = puzzle
    .components(separatedBy: .newlines)
    .map(Array.init)

// Part 1
var totalPriceByPerimeter = 0

// Part 2
var totalPriceBySideCount = 0

var visited: Set<[Int]> = []
for i in map.indices {
    for j in map[i].indices where visited.insert([i, j]).inserted {
        var sidesByDir: [[Int: Set<Int>]] = Array(repeating: [:], count: 4)
        let area = getRegion(i, j, &sidesByDir)
        
        let perimeter = sidesByDir
            .flatMap(\.values)
            .map(\.count)
            .reduce(into: 0, +=)
        
        totalPriceByPerimeter += area * perimeter
        
        let sideCount = sidesByDir
            .flatMap(\.values)
            .map {
                $0.sorted().chunked { $0 == $1 - 1 }.count
            }
            .reduce(into: 0, +=)
          
        totalPriceBySideCount += area * sideCount
    }
}

func getRegion(_ i: Int, _ j: Int, _ sides: inout [[Int: Set<Int>]]) -> Int {
    var area = 1
    
    for dir in [(-1, 0), (1, 0), (0, -1), (0, 1)].enumerated() {
        let (ni, nj) = (i + dir.element.0, j + dir.element.1)
        
        guard map.indices ~= ni, map[ni].indices ~= nj, map[i][j] == map[ni][nj] else {
            if dir.element.0 == 0 {
                sides[dir.offset][j, default: []].insert(i)
            } else {
                sides[dir.offset][i, default: []].insert(j)
            }
            
            continue
        }
        
        guard visited.insert([ni, nj]).inserted else {
            continue
        }
        
        area += getRegion(ni, nj, &sides)
    }
    
    return area
}
