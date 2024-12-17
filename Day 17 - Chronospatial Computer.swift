let register: (a: Int, b: Int, c: Int) = (729, 0, 0)
let program = [0, 1, 5, 4, 3, 0]

// Part 1
func process(_ a: Int, _ b: Int, _ c: Int) -> [Int] {
    var register: (a: Int, b: Int, c: Int) = (a, b, c)
    var pointer = 0
    var outputValues: [Int] = []
    
    while pointer < program.endIndex {
        let opcode = program[pointer]
        let literalOperand = program[pointer + 1]
        let comboOperand = switch program[pointer + 1] {
        case 4: register.a
        case 5: register.b
        case 6: register.c
        default: literalOperand
        }
        
        switch opcode {
        case 0:
            register.a >>= comboOperand
        case 1:
            register.b ^= literalOperand
        case 2:
            register.b = comboOperand % 8
        case 3 where register.a != 0:
            pointer = literalOperand
            continue
        case 4:
            register.b ^= register.c
        case 5:
            outputValues.append(comboOperand % 8)
        case 6:
            register.b = register.a >> comboOperand
        case 7:
            register.c = register.a >> comboOperand
        default:
            break
        }
        
        pointer += 2
    }
    
    return outputValues
}

// Part 2
if let base = (0...).first(where: { process($0, register.b, register.c).count > 1 }) {
    var initialValues = [0]
    
    for count in 1 ... program.count {
        initialValues = initialValues.flatMap { value in
            (0 ..< base)
                .map { value * base + $0 }
                .filter {
                    process($0, register.b, register.c).suffix(count) == program.suffix(count)
                }
        }
    }
}
