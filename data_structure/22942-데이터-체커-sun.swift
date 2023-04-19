/*
- https://www.acmicpc.net/problem/22942
- 자료구조(스택)

생각 과정
- 처음에는 단순히 직전 중 가장 큰 원이랑만 비교하면 된다고 생각했는데 예제 2를 보니까 가장 큰 원에는 포함되는데 
  내부에서 이전의 다른 원과 교차되는 경우가 있음을 깨달았다..ㅎ 
- 그래서 어케할까 하다가 걍 스택에 계속 저장하고 스택의 원들과 비교해서 적절히 push/pop 하면 되지 않을까 했음 
- 근데 나는 원의 시작과 끝을 모두 저장했는데 다른 사람들 풀이 보니까 그 괄호 문제처럼 끝만 저장하면 되는듯? 
*/

import Foundation

typealias Range = (start: Int, end: Int)

func solution(_ circles: [[Int]]) -> Bool {
    let circles = calculateRange(circles)
    var stack = [Range]()

    for (start, end) in circles {
        while let prev = stack.last {
            let isIncluded = start > prev.start && end < prev.end, isExcluded = start > prev.end

            if isIncluded {
                break
            } else if isExcluded {
                stack.removeLast()
            } else {
                return false
            }
        }

        stack.append((start, end))
    }

    return true
}

private func calculateRange(_ circles: [[Int]]) -> [Range] {
    let x = 0, r = 1
    var result = [Range]()

    for circle in circles {
        let x = circle[x], r = circle[r]

        result.append((x - r, x + r))
    }

    return result.sorted { $0.start != $1.start ? $0.start < $1.start : $0.end < $1.end }
}

var file = FileIO()

let N = file.readInt()
var circles = [[Int]]()

for _ in 0..<N {
    circles.append(file.readIntArray(2))
}

print(solution(circles) ? "YES" : "NO")


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
