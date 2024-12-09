import Algorithms

let puzzle = """
2333133121414131402
"""

let digits = puzzle.compactMap(\.wholeNumberValue)

let blocks: [Int] = zip((0...).interspersed(with: -1), digits)
    .flatMap { id, count in
        Array(repeating: id, count: count)
    }

// Part 1
var compactedBlocks = blocks

var fileIndices = blocks
    .indices
    .filter { blocks[$0] != -1 }

var spaceIndices = blocks
    .indices
    .reversed()
    .filter { blocks[$0] == -1 }

while let fileIndex = fileIndices.popLast(),
      let spaceIndex = spaceIndices.popLast(),
      spaceIndex < fileIndex {
    compactedBlocks.swapAt(fileIndex, spaceIndex)
}

// Part 2
var compactedBlocksByFile = blocks

let chunks = blocks.chunked { $0 == $1 }
var fileChunks = chunks.filter { $0.first != -1 }
var spaceChunks = chunks.filter { $0.first == -1 }

while let fileChunk = fileChunks.popLast() {
    guard let index = spaceChunks.firstIndex(where: { $0.count >= fileChunk.count && $0.startIndex < fileChunk.startIndex }) else {
        continue
    }

    for i in 0 ..< fileChunk.count {
        compactedBlocksByFile.swapAt(fileChunk.startIndex + i, spaceChunks[index].startIndex + i)
    }
    spaceChunks[index] = spaceChunks[index].dropFirst(fileChunk.count)
}

let checksum = compactedBlocksByFile
    .enumerated()
    .filter { $0.element != -1 }
    .map(*)
    .reduce(into: 0, +=)
