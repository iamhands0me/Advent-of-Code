import Foundation

let puzzle = """
3   4
4   3
2   5
1   3
3   9
3   3
"""

var leftList: [Int] = []
var rightList: [Int] = []
for row in puzzle.components(separatedBy: .newlines) {
    let nums = row
        .components(separatedBy: .whitespaces)
        .compactMap(Int.init)
    
    leftList.append(nums[0])
    rightList.append(nums[1])
}

// Part 1
let totalDistance = zip(leftList.sorted(), rightList.sorted())
    .map { abs($0.0 - $0.1) }
    .reduce(into: 0, +=)

// Part 2
let rightCountsByNum = rightList
    .reduce(into: [Int: Int]()) { $0[$1, default: 0] += 1 }

let similarityScore = leftList
    .map { $0 * rightCountsByNum[$0, default: 0] }
    .reduce(into: 0, +=)
