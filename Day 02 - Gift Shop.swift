import Algorithms
import Foundation

let puzzle = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

// Part 1
let invalidSum: Int = puzzle
    .split(separator: ",")
    .map { range in
        range
            .split(separator: "-")
            .compactMap { Int($0) }
    }
    .flatMap {
        Array($0[0] ... $0[1])
    }
    .filter { (id: Int) -> Bool in
        Set(
            String(id).evenlyChunked(in: 2)
        )
        .count == 1
    }
    .reduce(0, +)

// Part 2
let newInvalidSum: Int = puzzle
    .split(separator: ",")
    .map { range in
        range
            .split(separator: "-")
            .compactMap { Int($0) }
    }
    .flatMap {
        Array($0[0] ... $0[1])
    }
    .filter { (id: Int) -> Bool in
        (1 ..< String(id).count)
            .contains {
                Set(
                    String(id).chunks(ofCount: $0)
                )
                .count == 1
            }
    }
    .reduce(0, +)
