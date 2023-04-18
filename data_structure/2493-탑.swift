/*
- https://www.acmicpc.net/problem/2493
- 자료구조(스택)

생각 과정
- 첨에 뭔가 스택쓰면 되지 않을까했는데 시간복잡도가 되나 하는 생각이 들었다...
  pop을 반복하니까 2중 반복문이 되는데 이거 되나?! 싶은 마음...ㅋㅎ
- 근데 결국 따져보면 유효한 숫자를 찾을 때까지만 계속 pop하고 이때 pop된 건 (유효하지 않다면) 바로 버려지기 때문에 
  pop의 총 횟수는 결국 n이 되므로 스택을 사용하면 시간복잡도는 바깥 for문이 n, pop while문이 전체 합쳐서 n이므로
  O(2n) -> O(n) 이니까 넉넉~
*/

import Foundation

typealias Info = (index: Int, length: Int)

func solution(_ numbers: [Int]) -> [Int] {
    var stack = [Info](), answer = Array(repeating: 0, count: numbers.count)

    for index in 0..<numbers.count {
        let length = numbers[index]
        while let prev = stack.popLast() {
            if prev.length >= length {
                answer[index] = prev.index
                stack.append(prev)
                break
            }
        }
        stack.append((index + 1, length))
    }

    return answer
}

var file = FileIO()

let K = file.readInt()
let numbers = file.readIntArray(K)

print(solution(numbers).map { String($0) }.joined(separator: " "))


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
