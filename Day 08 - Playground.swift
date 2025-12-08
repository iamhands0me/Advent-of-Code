import Algorithms
import Foundation
import simd

let puzzle = """
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
"""

func circuit(of box: SIMD3<Float>) -> (root: SIMD3<Float>, count: Int) {
    if let root = circuits[box]?.root, root != box {
        circuits[box] = circuit(of: root)
    }
    
    return circuits[box] ?? (box, 1)
}

func connect(_ box1: SIMD3<Float>, _ box2: SIMD3<Float>) {
    let circuit1 = circuit(of: box1)
    let circuit2 = circuit(of: box2)
    
    if circuit1.root == circuit2.root { return }
    
    circuits[circuit1.root]?.count += circuit2.count
    circuits[circuit2.root] = circuits[circuit1.root]
}

let boxes: [SIMD3<Float>] = puzzle
    .components(separatedBy: .newlines)
    .map {
        $0
            .components(separatedBy: ",")
            .compactMap(Float.init)
    }
    .map {
        SIMD3(x: $0[0], y: $0[1], z: $0[2])
    }

var circuits: [SIMD3<Float>: (root: SIMD3<Float>, count: Int)] = Dictionary(
    uniqueKeysWithValues: boxes.map { ($0, ($0, 1)) }
)

// Part 1
boxes
    .combinations(ofCount: 2)
    .min(count: 1000) { distance($0[0], $0[1]) < distance($1[0], $1[1]) }
    .forEach { connect($0[0], $0[1]) }

let product = boxes
    .map(circuit)
    .keyed(by: \.root)
    .map(\.value.count)
    .max(count: 3)
    .reduce(1, *)

// Part 2
let targetDistance: Int = {
    for pair in boxes.combinations(ofCount: 2).sorted(by: { distance($0[0], $0[1]) < distance($1[0], $1[1]) }) {
        connect(pair[0], pair[1])
        
        if circuit(of: pair[0]).count == boxes.count {
            return Int(pair[0][0]) * Int(pair[1][0])
        }
    }
    
    return 0
}()
