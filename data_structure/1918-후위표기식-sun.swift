/*
- https://www.acmicpc.net/problem/1918
- 자료구조(스택)

생각과정
- 사실 분할정복으로 풀었다 뭔가 수많은 시행착오와 수정을 곁들인... 
- 반복문을 총 3번 돌면서 처음에는 괄호를 만날 때마다 재귀적으로 걔를 먼저 연산하도록 하고
  두 번째 반복문에서는 곱셈이랑 나눗셈을 처리하고 
  세 번째 반목문에서는 덧셈이랑 뺄셈을 처리하는 식
- 다른 사람들 풀이보니까 스택 하나 가지고 일정한 규칙을 설정해서 하던데 따라해봤는데 사실 이해는 잘 안 감... 
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

    @inline(__always) mutating func readInt() -> Int {
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

    mutating func readIntArray(_ K: Int) -> [Int] {
        var array = [Int]()

        for _ in 0..<K {
            array.append(readInt())
        }

        return array
    }

    @inline(__always) mutating func readString() -> String {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return String(bytes: Array(buffer[beginIndex..<(index-1)]), encoding: .ascii)!
    }

    mutating func readStringArray(_ K: Int) -> [String] {
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
print(solution(file.readString()))


// MARK: - Solution

private let lo = "(", hi = ")"

func solution(_ expression: String) -> String {
    dq(expression.map { String($0) })
}

private func dq(_ expression: [String]) -> String {
    let braceRemoved = handleBraces(in: expression)
    let multAndDiv = handleOperators(in: braceRemoved, operators: ["*", "/"])
    let addAndSub = handleOperators(in: multAndDiv, operators: ["+", "-"])

    return addAndSub.joined()
}

private func handleBraces(in expression: [String]) -> [String] {
    let start = "(", end = ")"
    var stack = [String](), result = [String](), count = 0

    for term in expression {
        count += term == start ? 1 : term == end ? -1 : 0

        if count != 0 {
            stack.append(term)
        } else if term == end {
            stack.removeFirst()
            result.append(dq(stack))
            stack.removeAll()
        } else {
            result.append(term)
        }
    }

    return result
}

private func handleOperators(in expression: [String], operators: [String]) -> [String] {
    var result = [String]()

    for term in expression {
        guard !operators.contains(term), operators.contains(result.last ?? "")
        else {
            result.append(term)
            continue
        }

        let op = result.removeLast(), a = result.removeLast()
        result.append(a + term + op)
    }

    return result
}
