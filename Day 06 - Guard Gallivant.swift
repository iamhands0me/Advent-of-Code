import Foundation

let puzzle = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""

var area: [[Character]] = puzzle
    .components(separatedBy: .newlines)
    .map(Array.init)

var startPoint = (-1, -1)
var startDir = (0, 0)
for i in area.indices {
    for j in area[i].indices {
        if "^>v<".contains(area[i][j]) {
            startPoint = (i, j)
            
            startDir = switch area[i][j] {
            case "^": (-1, 0)
            case ">": (0, 1)
            case "v": (1, 0)
            default: (0, -1)
            }
            
            break
        }
    }
}

// Part 1
var visitedCount = 0
var visitedIndices: [(Int, Int)] = []

_ = leaveMappedArea(&area, startPoint, startDir)

for i in area.indices {
    for j in area[i].indices where area[i][j] == "x" {
        visitedCount += 1
        visitedIndices.append((i, j))
    }
}

// Part 2
var newObstructionCount = 0

for (i, j) in visitedIndices where (i, j) != startPoint {
    area[i][j] = "#"
    if !leaveMappedArea(&area, startPoint, startDir) {
        newObstructionCount += 1
    }
    area[i][j] = "x"
}

func leaveMappedArea(_ area: inout [[Character]],
                     _ startPoint: (Int, Int),
                     _ startDir: (Int, Int)) -> Bool {
    var point = startPoint
    var dir = startDir
    var visitedObstructions: Set<[Int]> = []
    
    while area.indices ~= point.0,
          area[point.0].indices ~= point.1 {
        if area[point.0][point.1] == "#" {
            guard visitedObstructions.insert([point.0, point.1, dir.0, dir.1]).inserted else {
                return false
            }
            
            point = (point.0 - dir.0, point.1 - dir.1)
            dir = switch dir {
            case (-1, 0): (0, 1)
            case (0, 1): (1, 0)
            case (1, 0): (0, -1)
            default: (-1, 0)
            }
        } else {
            area[point.0][point.1] = "x"
        }
        
        point = (point.0 + dir.0, point.1 + dir.1)
    }
    
    return true
}
