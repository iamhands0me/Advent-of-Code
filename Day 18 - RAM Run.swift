import Collections
import Foundation

let puzzle = """
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
"""
let range = (0...6)

let byteIndices = puzzle
    .components(separatedBy: .newlines)
    .map {
        $0.components(separatedBy: ",").compactMap(Int.init)
    }

// Part 1
let fallenByteIndices = Set(byteIndices.prefix(12))
var stepCount: Int?

var steps = Array(
    repeating: Array(repeating: Int.max, count: range.count),
    count: range.count
)
steps[0][0] = 0

var queue: Deque<(x: Int, y: Int)> = [(0, 0)]
while let index = queue.popFirst() {
    for dir in [(0, 1), (0, -1), (1, 0), (-1, 0)] {
        let x = index.x + dir.0
        let y = index.y + dir.1
        
        guard range ~= y,
              range ~= x,
              !fallenByteIndices.contains([x, y]),
              steps[y][x] > steps[index.y][index.x] + 1 else {
            continue
        }
        
        steps[y][x] = steps[index.y][index.x] + 1
        queue.append((x, y))
    }
}

stepCount = steps[range.upperBound][range.upperBound]

// Part 2
var fallingByteIndices = OrderedSet(byteIndices)
var firstFallingByteIndex: (x: Int, y: Int)?

var roots: [[(x: Int, y: Int)]] = range
    .map { y in
        range.map { x in (x, y) }
    }

for y in range {
    for x in range {
        for dir in [(0, 1), (0, -1), (1, 0), (-1, 0)] {
            union(x, y, x + dir.0, y + dir.1)
        }
    }
}

while !fallingByteIndices.isEmpty {
    let index = fallingByteIndices.removeLast()
    let (x, y) = (index[0], index[1])
    
    for dir in [(0, 1), (0, -1), (1, 0), (-1, 0)] {
        union(x, y, x + dir.0, y + dir.1)
    }
    
    if find(0, 0) == find(range.upperBound, range.upperBound) {
        firstFallingByteIndex = (x, y)
        break
    }
}

func find(_ x: Int, _ y: Int) -> (x: Int, y: Int) {
    if (x, y) != roots[y][x] {
        roots[y][x] = find(roots[y][x].x, roots[y][x].y)
    }
    
    return roots[y][x]
}

func union(_ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int) {
    guard range ~= x1, range ~= y1,
          range ~= x2, range ~= y2,
          !fallingByteIndices.contains([x1, y1]),
          !fallingByteIndices.contains([x2, y2]) else {
        return
    }
    
    let root1 = find(x1, y1)
    let root2 = find(x2, y2)
    
    roots[root1.y][root1.x] = root2
}
