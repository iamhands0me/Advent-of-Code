import Foundation

let puzzle = """
8793800 1629 65 5 960 0 138983 85629
"""

let engravedNums = puzzle
    .components(separatedBy: .whitespaces)
    .compactMap(Int.init)

var stoneCountsDict: [[Int]: Int] = [:]

// Part 1 & 2
let stoneCount = engravedNums
    .map {
        changedStoneCount(of: $0, after: 75)
    }
    .reduce(into: 0, +=)

func changedStoneCount(of engravedNum: Int, after blink: Int) -> Int {
    guard blink > 0 else { return 1 }

    if let count = stoneCountsDict[[engravedNum, blink]] {
        return count
    }

    let count = {
        if engravedNum == 0 {
            return changedStoneCount(of: 1, after: blink - 1)
        }

        let str = String(engravedNum)
        if str.count.isMultiple(of: 2),
           let prefix = Int(str.prefix(str.count / 2)),
           let suffix = Int(str.suffix(str.count / 2)) {
            let leftCount = changedStoneCount(of: prefix, after: blink - 1)
            let rightCount = changedStoneCount(of: suffix, after: blink - 1)
            return leftCount + rightCount
        }

        return changedStoneCount(of: engravedNum * 2024, after: blink - 1)
    }()

    stoneCountsDict[[engravedNum, blink]] = count
    return count
}
