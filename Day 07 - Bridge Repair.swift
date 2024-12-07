import Foundation

let puzzle = """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"""

var sum = 0

for equation in puzzle.components(separatedBy: .newlines) {
    let nums = equation
        .replacingOccurrences(of: ":", with: "")
        .components(separatedBy: .whitespaces)
        .compactMap(Int.init)
    
    if isProducible(to: nums[0], with: nums.dropFirst()) {
        sum += nums[0]
    }
}

func isProducible(to target: Int, with nums: ArraySlice<Int>) -> Bool {
    guard let lastNum = nums.last else {
        return target == 0
    }
    
    // Part 1
    if isProducible(to: target - lastNum, with: nums.dropLast(1)) {
        return true
    }
    
    if target.isMultiple(of: lastNum),
       isProducible(to: target / lastNum, with: nums.dropLast(1)) {
        return true
    }
    
    // Part 2
    let lastNumStr = "\(lastNum)"
    let targetStr = "\(target)"
    if targetStr.hasSuffix(lastNumStr),
       let leftTarget = Int(targetStr.dropLast(lastNumStr.count)),
       isProducible(to: leftTarget, with: nums.dropLast(1)) {
        return true
    }
    
    return false
}
