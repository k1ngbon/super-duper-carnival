/*
- https://www.acmicpc.net/problem/5430
- 자료구조(덱)

# 생각과정
- 막연히 찐 배열을 뒤집지 말고 걍 isReversed 변수를 두고 이걸 확인해서 앞/뒤 중 적절히 제거하면 어떨까 했는데 
  이렇게 하려면 덱을 구현해야 했다...ㅎ 이래서 덱이군 했음ㅋㅋㅋㅋ
- 덱은 그냥 cursor 큐 구현하는 방식을 살짝 변형해서 구함 
- 카테고리 알아서 바로 풀었는데 몰랐으면 꽤 어려웠을 것 같은...?
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

    mutating func readIntArray(_ K: Int) -> [Int] {
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

// MARK: - Solution

var answers = [String]()

for _ in 0..<file.readInt() {
    let cmd = file.readString()
    file.readString()
    let numbers = file.readString().components(separatedBy: .punctuationCharacters).compactMap { Int(String($0)) }
    let result = solution(cmd, numbers)
    let answer = result == nil ? "error" : "[" + result!.map { String($0) }.joined(separator: ",") + "]"
    answers.append(answer)
}

print(answers.joined(separator: "\n"))


struct Deque<T> {

    var array: [T] { (startIndex..<endIndex).map { elements[$0] } }
    private var elements = [T]()
    private var startIndex = 0
    private var endIndex: Int { elements.endIndex }

    init(_ elements: [T]) {
        self.elements = elements
    }

    mutating func push(_ element: T) {
        elements.append(element)
    }

    mutating func popFirst() -> T? {
        guard startIndex != endIndex else { return nil }

        startIndex += 1
        return elements[startIndex - 1]
    }

    mutating func popLast() -> T? {
        guard startIndex != endIndex else { return nil }

        return elements.removeLast()
    }
}
func solution(_ cmd: String, _ numbers: [Int]) -> [Int]? {
    let drop: Character = "D"
    var isReversed = false, dq = Deque(numbers)

    for cmd in cmd {
        guard cmd == drop
        else {
            isReversed.toggle()
            continue
        }

        if (isReversed ? dq.popLast() : dq.popFirst()) == nil {
            return nil 
        }
    }

    return isReversed ? dq.array.reversed() : dq.array
}
