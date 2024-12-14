let puzzle = """
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
"""

let (w, h) = (101, 103)
var robots: [Robot] = []

for line in puzzle.matches(of: /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/) {
    guard let positionX = Int(line.1),
          let positionY = Int(line.2),
          let velocityX = Int(line.3),
          let velocityY = Int(line.4) else {
        continue
    }
    
    robots.append(Robot(position: (positionX, positionY), velocity: (velocityX, velocityY)))
}

// Part 1
var robotsAfter100Seconds = robots
for _ in 0 ..< 100 {
    for i in robotsAfter100Seconds.indices {
        robotsAfter100Seconds[i].move()
    }
}

var countsByQuadrant: [[Int]] = [[0, 0], [0, 0]]
for position in robotsAfter100Seconds.map(\.position) {
    guard position.x != w / 2, position.y != h / 2 else {
        continue
    }
    
    let quadrant = (position.x * 2 / w, position.y * 2 / h)
    countsByQuadrant[quadrant.0][quadrant.1] += 1
}

let safetyFactor = countsByQuadrant
    .flatMap { $0 }
    .reduce(into: 1, *=)

// Part 2
var second = 0

outer: while second < w * h {
    for i in robots.indices {
        robots[i].move()
    }
    second += 1
    
    let robotPositions = Set(robots.map(\.position).map { [$0.x, $0.y] })
    
    for (x, y) in robots.map(\.position) {
        let xmasTreePoints = Set([
            [x, y],
            [x - 1, y + 1], [x, y + 1], [x + 1, y + 1],
            [x - 2, y + 2], [x - 1, y + 2], [x, y + 2], [x + 1, y + 2], [x + 2, y + 2]
        ])
        if xmasTreePoints.isSubset(of: robotPositions) {
            break outer
        }
    }
}

struct Robot {
    var position: (x: Int, y: Int)
    let velocity: (x: Int, y: Int)
    
    mutating func move() {
        position.x = (position.x + velocity.x + w) % w
        position.y = (position.y + velocity.y + h) % h
    }
}
