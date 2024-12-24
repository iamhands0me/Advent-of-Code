import Foundation

let puzzle = """
x00: 1
x01: 1
x02: 1
y00: 0
y01: 1
y02: 0

x00 AND y00 -> z00
x01 XOR y01 -> z01
x02 OR y02 -> z02
"""

let puzzles = puzzle.components(separatedBy: "\n\n")

var wireValues: [Substring: Int] = [:]

for wire in puzzles[0].matches(of: /(\w+): ([0-1])/) {
    guard let initialValue = Int(wire.2) else { continue }
    
    wireValues[wire.1] = initialValue
}

var outputsByInput: [Substring: [Substring]] = [:]
var waitingInputCountsByOutput: [Substring: Int] = [:]
var connectionsByOutput: [Substring: [Substring]] = [:]

for connection in puzzles[1].matches(of: /(\w+) (\w+) (\w+) -> (\w+)/) {
    outputsByInput[connection.1, default: []].append(connection.4)
    outputsByInput[connection.3, default: []].append(connection.4)
    
    waitingInputCountsByOutput[connection.4] = 2
    
    connectionsByOutput[connection.4] = [
        connection.1, connection.2, connection.3, connection.4
    ]
}

var stack: [[Substring]] = []
for wire in wireValues.keys {
    for output in outputsByInput[wire, default: []] {
        waitingInputCountsByOutput[output, default: 0] -= 1
        
        if waitingInputCountsByOutput[output] == 0,
           let connection = connectionsByOutput[output] {
            stack.append(connection)
        }
    }
}

while let connection = stack.popLast() {
    guard let lhs = wireValues[connection[0]],
          let rhs = wireValues[connection[2]] else { continue }
    
    let outputValue = switch connection[1] {
    case "AND":
        return lhs & rhs
    case "OR":
        return lhs | rhs
    default:
        return lhs ^ rhs
    }
    
    wireValues[connection[3]] = outputValue
    
    for output in outputsByInput[connection[3], default: []] {
        waitingInputCountsByOutput[output, default: 0] -= 1
        if waitingInputCountsByOutput[output] == 0,
           let connection = connectionsByOutput[output] {
            stack.append(connection)
        }
    }
}

// Part 1
let producedNum = wireValues
    .filter { $0.key.starts(with: "z") }
    .sorted { $0.key > $1.key }
    .map(\.value)
    .reduce(into: 0) { $0 = ($0 << 1) | $1 }
