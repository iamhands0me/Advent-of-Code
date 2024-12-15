import Foundation

let puzzle = """
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
"""

let puzzles = puzzle
    .components(separatedBy: "\n\n")

// Part 2
var wideMap: [[Character]] = puzzles[0]
    .components(separatedBy: .newlines)
    .map {
        $0.flatMap {
            switch $0 {
            case "#": return "##"
            case "O": return "[]"
            case "@": return "@."
            default: return ".."
            }
        }
    }

let dirs: [(i: Int, j: Int)] = puzzles[1]
    .compactMap {
        switch $0 {
        case "^": return (-1, 0)
        case "v": return (1, 0)
        case ">": return (0, 1)
        case "<": return (0, -1)
        default: return nil
        }
    }

var pos: (i: Int, j: Int) = (0, 0)
for i in wideMap.indices {
    for j in wideMap[i].indices {
        if wideMap[i][j] == "@" {
            pos = (i, j)
        }
    }
}

for dir in dirs {
    let newPos: (i: Int, j: Int) = (pos.i + dir.i, pos.j + dir.j)
    
    guard wideMap[newPos.i][newPos.j] != "#" else { continue }
    
    var isMovable = true
    var movingBoxes: Set<[Int]> = []
    var stack: [(i: Int, j: Int)] = []
    
    if wideMap[newPos.i][newPos.j] == "[" {
        movingBoxes.insert([newPos.i, newPos.j])
        stack.append(newPos)
    } else if wideMap[newPos.i][newPos.j] == "]" {
        movingBoxes.insert([newPos.i, newPos.j - 1])
        stack.append((newPos.i, newPos.j - 1))
    }
    
    while var box = stack.popLast() {
        box.i += dir.i
        box.j += dir.j
        
        guard wideMap[box.i][box.j] != "#",
              wideMap[box.i][box.j + 1] != "#" else {
            isMovable = false
            break
        }
        
        for point in (-1 ... 1).map({ (i: box.i, j: box.j + $0) }) {
            if wideMap[point.i][point.j] == "[",
               movingBoxes.insert([point.i, point.j]).inserted {
                stack.append(point)
            }
        }
    }
    
    if isMovable {
        for box in movingBoxes {
            wideMap[box[0]][box[1]] = "."
            wideMap[box[0]][box[1] + 1] = "."
        }
        for box in movingBoxes {
            wideMap[box[0] + dir.i][box[1] + dir.j] = "["
            wideMap[box[0] + dir.i][box[1] + dir.j + 1] = "]"
        }
        pos = newPos
    }
}

var sum = 0
for i in wideMap.indices {
    for j in wideMap[i].indices where wideMap[i][j] == "[" {
        sum += 100 * i + j
    }
}
