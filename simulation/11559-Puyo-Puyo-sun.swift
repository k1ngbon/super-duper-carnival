/*
- https://www.acmicpc.net/problem/11559
- 구현

# 생각과정
- 터질 수 있는 뿌요가 여러 그룹이 있으면 동시에 터져야 되니까 일단 그룹을 찾으면 터뜨리고 
  아래로 이동하는 건 모든 그룹을 다 찾은 다음에 해야됨... 
- 그룹 찾는 건 완탐으로 각 좌표마다 dfs로 그룹을 찾아서 4개 이상일 때만 유효하다고 리턴
- 중력 이동은 어케하지..? 뭔가 하나하나 확인하면 복잡할 거 같은데 
  바닥부터 첫 번째 뿌요까지 높이를 재서 한번에 이동시키는 건...? 
- 위의 방법은 [바닥 - 뿌요 - (뿌요가 터지고 남은)빈 공간 - 뿌요] 와 같은 경우를 처리하지 못함
  할려면 할 수는 있는데 복잡할듯... 
- 어차피 12 x 6 으로 그래프 크기가 작으니까 그냥 열마다 돌면서 남은 뿌요를 스택에 쌓고, 
  스택에 쌓인 뿌요를 새로운 빈 그래프의 적절한 위치에 옮겨주면 될 듯? 
- 출력문을 지웠는지 확인하고 제출하자...ㅎ
*/

import Foundation

// MARK: - FileIO

struct FileIO {
    private let buffer:[UInt8]
    private var index: Int = 0

    init(fileHandle: FileHandle = FileHandle.standardInput) {

        buffer = Array(try! fileHandle.readToEnd()!)+[UInt8(0)] // 인덱스 범위 넘어가는 것 방지
    }

    @inline(__always) private mutating func read() -> UInt8 {
        defer { index += 1 }

        return buffer[index]
    }

    @inline(__always) @discardableResult mutating func readInt() -> Int {
        var sum = 0
        var now = read()
        var isPositive = true

        while now == 10
                || now == 32 { now = read() } // 공백과 줄바꿈 무시
        if now == 45 { isPositive.toggle(); now = read() } // 음수 처리
        while now >= 48, now <= 57 {
            sum = sum * 10 + Int(now-48)
            now = read()
        }

        return sum * (isPositive ? 1:-1)
    }

    @discardableResult mutating func readIntArray(_ K: Int) -> [Int] {
        var array = [Int]()

        for _ in 0..<K {
            array.append(readInt())
        }

        return array
    }

    @inline(__always) @discardableResult mutating func readString() -> String {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return String(bytes: Array(buffer[beginIndex..<(index-1)]), encoding: .ascii)!
    }

    @discardableResult mutating func readStringArray(_ K: Int) -> [String] {
        var array = [String]()

        for _ in 0..<K {
            array.append(readString())
        }

        return array
    }

    @inline(__always) mutating func readByteSequenceWithoutSpaceAndLineFeed() -> [UInt8] {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return Array(buffer[beginIndex..<(index-1)])
    }
}

var file = FileIO()

var field = Field()

for _ in 0..<12 {
    field.append(file.readString().map { String($0) })
}

print(solution(field))


// MARK: - Solution

typealias Field = [[String]]
typealias Coordinate = (r: Int, c: Int)

func solution(_ field: Field) -> Int {
    var streakCount = 0, field = field

    while true {
        guard didPopCombos(in: &field) else { break }

        streakCount += 1
    }

    return streakCount
}

private func didPopCombos(in field: inout Field) -> Bool {
    var didPopCombos = false
    let empty = "."

    for row in 0..<field.count {
        for col in 0..<field[0].count {
            guard field[row][col] != empty,
                  let combo = findCombo(in: field, start: (row, col))
            else { continue }

            popCombo(combo, field: &field)
            didPopCombos = true
        }
    }

    if didPopCombos {
        applyGravity(in: &field)
    }

    return didPopCombos
}

private func findCombo(in field: Field, start: Coordinate) -> [Coordinate]? {
    let empty = ".", directions = [(1, 0), (-1, 0), (0, 1), (0, -1)], color = field[start.r][start.c]
    var combo = [start], stack = combo, field = field
    field[start.r][start.c] = empty

    while let (row, col) = stack.popLast() {
        for (dr, dc) in directions {
            let nr = row + dr, nc = col + dc
            guard field[safe: nr]?[safe: nc] == color else { continue }

            field[nr][nc] = empty
            stack.append((nr, nc))
            combo.append((nr, nc))
        }
    }

    return combo.count < 4 ? nil : combo
}

private func popCombo(_ combo: [Coordinate], field: inout Field) {
    let empty = "."

    for (row, col) in combo {
        field[row][col] = empty
    }
}

private func applyGravity(in field: inout Field) {
    let empty = "."
    var newField = Array(repeating: Array(repeating: empty, count: 6), count: 12)

    for col in 0..<field[0].count {
        var cells = (0..<12).compactMap { field[$0][col] != empty ? field[$0][col] : nil }
        var row = 11

        while let color = cells.popLast() {
            newField[row][col] = color
            row -= 1
        }
    }

    field = newField
}

extension Array {

    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
