import Algorithms
import Foundation

let puzzle = """
1
2
3
2024
"""

let nums = puzzle
    .components(separatedBy: .newlines)
    .compactMap(Int.init)

// Part 1
var sum = 0

// Part 2
var firstPricesByWindow: [ArraySlice<Int>: [Int: Int]] = [:]
var maxPrice: Int?

for (i, num) in nums.enumerated() {
    let secretNums = secretNums(of: num)
    sum += secretNums.last ?? 0
    
    let futurePrices = ([num] + secretNums).map { $0 % 10 }
    let changeSequence = futurePrices.adjacentPairs().map(-)
    
    for window in changeSequence.windows(ofCount: 4) {
        guard firstPricesByWindow[window]?[i] == nil else {
            continue
        }
        
        let price = futurePrices[window.endIndex]
        firstPricesByWindow[window, default: [:]][i] = price
    }
}

maxPrice = firstPricesByWindow
    .map(\.value)
    .map { $0.map(\.value).reduce(into: 0, +=) }
    .max()

func secretNums(of num: Int) -> [Int] {
    var nums: [Int] = []
    var secretNum = num
    
    for _ in 0 ..< 2000 {
        secretNum = (secretNum ^ (secretNum << 6)) & ((1 << 24) - 1)
        secretNum = (secretNum ^ (secretNum >> 5)) & ((1 << 24) - 1)
        secretNum = (secretNum ^ (secretNum << 11)) & ((1 << 24) - 1)
        
        nums.append(secretNum)
    }
    
    return nums
}
