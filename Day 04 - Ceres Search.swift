import Foundation

let puzzle = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""

let letters: [[Character]] = puzzle
    .components(separatedBy: .newlines)
    .map(Array.init)

// Part 1
var xmasCount = 0

for i in letters.indices {
    for j in letters[i].indices {
        for dir in [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (1, -1), (-1, 1), (-1, -1)] {
            var word = ""
            for (r, c) in (0...3).map({ (i + dir.0 * $0, j + dir.1 * $0) }) {
                guard letters.indices ~= r, letters[r].indices ~= c else {
                    break
                }
                
                word.append(letters[r][c])
            }
            
            if word == "XMAS" {
                xmasCount += 1
            }
        }
    }
}

// Part 2
var x_masCount = 0

for i in 1 ..< (letters.endIndex - 1) {
    for j in 1 ..< (letters[i].endIndex - 1) where letters[i][j] == "A" {
        if Set([letters[i - 1][j - 1], letters[i + 1][j + 1]]) == Set("MS"),
           Set([letters[i - 1][j + 1], letters[i + 1][j - 1]]) == Set("MS") {
            x_masCount += 1
        }
    }
}
