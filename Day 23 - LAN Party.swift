import Foundation

let puzzle = """
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
"""

let networkMap = puzzle.components(separatedBy: .newlines)

var graph: [String: Set<String>] = [:]

for connection in networkMap {
    let computers = connection.components(separatedBy: "-")
    graph[computers[0], default: []].insert(computers[1])
    graph[computers[1], default: []].insert(computers[0])
}

var groups: Set<[String]> = []
var stack: [(group: [String], connections: Set<String>)] = graph.map {
    ([$0.key], $0.value)
}

while let (group, connections) = stack.popLast() {
    guard groups.insert(group).inserted else { continue }
    
    for connectedComputer in connections {
        stack.append((
            (group + [connectedComputer]).sorted(),
            connections.intersection(graph[connectedComputer] ?? [])
        ))
    }
}

// Part 1
let threeComputersGroups = groups.filter { $0.count == 3 }
let count = threeComputersGroups
    .filter { $0.contains { $0.starts(with: "t") } }
    .count

// Part2
let maxGroup = groups.max { $0.count < $1.count }
let password = maxGroup?.joined(separator: ",")
