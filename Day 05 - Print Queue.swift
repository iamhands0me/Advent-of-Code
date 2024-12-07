import Foundation

let puzzle = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""

let puzzles = puzzle.components(separatedBy: "\n\n")

var rightPages: [Int: Set<Int>] = [:]
for rule in puzzles[0].components(separatedBy: .newlines) {
    let pages = rule
        .components(separatedBy: "|")
        .compactMap(Int.init)
    
    rightPages[pages[0], default: []].insert(pages[1])
}

// Part 1
var correctOrderSum = 0

// Part 2
var incorrectOrderSum = 0

for ordering in puzzles[1].components(separatedBy: .newlines) {
    let pages = ordering
        .components(separatedBy: ",")
        .compactMap(Int.init)
    
    let sortedPages = pages.sorted {
        !rightPages[$1, default: []].contains($0)
    }
    
    let middlePage = sortedPages[sortedPages.count / 2]
    if pages == sortedPages {
        correctOrderSum += middlePage
    } else {
        incorrectOrderSum += middlePage
    }
}
