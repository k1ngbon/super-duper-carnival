/*
- https://www.acmicpc.net/problem/14891
- 구현

# 생각과정
- 회전 횟수가 100 이하고, 톱니바퀴도 길이가 8에 4개밖에 없으니까 걍 덱 말고 배열 써도 되겠다.. 
- 좌우 교차점이랑 시계/반시계 회전 필요하니까 아예 Wheel 구조체로 묶을까..? 
- 매 명령마다 회전시켜야 되는 모든 바퀴 어케 구하지? 인덱스 순으로는 안되고..dfs해야될 듯
- 최종 점수 도출 2진법인거 알았는데도 첨에는 reduce로 복잡하게 했다가 Int(value:radix:) 사용하면 더 간단한 걸 깨달아서 변경~
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

var wheels = [[Int]]()

for _ in 0..<4 {
    wheels.append(file.readString().map { Int(String($0))! })
}

var rotations = [[Int]]()

for _ in 0..<file.readInt() {
    let index = file.readInt() - 1, dir = file.readInt()
    rotations.append([index, dir])
}

print(solution(wheels, rotations))


// MARK: - Solution

typealias Rotation = (index: Int, isClockwise: Bool)

func solution(_ wheels: [[Int]], _ rotations: [[Int]]) -> Int {
    let clockwise = 1
    var wheels = wheels.map { Wheel(elements: $0) }

    for rotation in rotations {
        let index = rotation[0], isClockwise = rotation[1] == clockwise
        findRotatingWheels(wheels, command: (index, isClockwise)).forEach {
            wheels[$0.index].rotate(isClockwise: $0.isClockwise)
        }
    }

    return Int(String(wheels.map { String($0.twelveOClock) }.joined().reversed()), radix: 2)!
}

private func findRotatingWheels(_ wheels: [Wheel], command: Rotation) -> [Rotation] {
    var rotating = [command], stack = rotating
    var visited = Array(repeating: false, count: 4)
    let leftWheel = -1, rightWheel = 1
    visited[command.index].toggle()

    while let (index, isClockwise) = stack.popLast() {
        let wheel = wheels[index], leftWheel = index + leftWheel, rightWheel = index + rightWheel

        if visited[safe: leftWheel] == false,
           wheel.leftIntersection != wheels[leftWheel].rightIntersection {

            visited[leftWheel].toggle()
            let wheel = (leftWheel, !isClockwise)
            stack.append(wheel)
            rotating.append(wheel)
        }

        if visited[safe: rightWheel] == false,
           wheel.rightIntersection != wheels[rightWheel].leftIntersection {

            visited[rightWheel].toggle()
            let wheel = (rightWheel, !isClockwise)
            stack.append(wheel)
            rotating.append(wheel)
        }
    }

    return rotating
}

struct Wheel {

    var leftIntersection: Int { elements[6] }
    var rightIntersection: Int { elements[2] }
    var twelveOClock: Int { elements[0] }
    private(set) var elements = [Int]()

    init(elements: [Int]) {
        self.elements = elements
    }

    mutating func rotate(isClockwise: Bool) {
        if isClockwise {
            elements.insert(elements.removeLast(), at: 0)
        } else {
            elements.append(elements.removeFirst())
        }
    }
}

extension Array {

    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
