let puzzle = """
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
"""

// Part 1
var sum = 0

// Part 2
var isEnabled = true
var conditionalSum = 0

for match in puzzle.matches(of: /mul\((\d+),(\d+)\)|do\(\)|don't\(\)/) {
    switch match.output.0 {
    case "do()":
        isEnabled = true
    case "don't()":
        isEnabled = false
    default:
        if let lhs = match.output.1.flatMap({ Int($0) }),
           let rhs = match.output.2.flatMap({ Int($0) }) {
            sum += lhs * rhs
            if isEnabled {
                conditionalSum += lhs * rhs
            }
        }
    }
}
