let puzzle = """
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
"""

var sum = 0

for machine in puzzle.matches(of: /Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)/) {
    guard let xa = Int(machine.1),
          let ya = Int(machine.2),
          let xb = Int(machine.3),
          let yb = Int(machine.4),
          var prizeX = Int(machine.5),
          var prizeY = Int(machine.6) else {
        continue
    }

    prizeX += 10000000000000
    prizeY += 10000000000000

    /*
     xa * countA + xb * countB = prizeX
     ya * countA + yb * countB = prizeY
     */
    let countA: Int? = {
        let numerator = prizeX * yb - prizeY * xb
        let denominator = xa * yb - ya * xb

        guard numerator.isMultiple(of: denominator) else { return nil }

        return numerator / denominator
    }()

    let countB: Int? = {
        let numerator = prizeX * ya - prizeY * xa
        let denominator = xb * ya - yb * xa

        guard numerator.isMultiple(of: denominator) else { return nil }

        return numerator / denominator
    }()

    if let countA, let countB {
        sum += 3 * countA + countB
    }
}
