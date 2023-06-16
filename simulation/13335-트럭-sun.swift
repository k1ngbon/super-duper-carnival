/*
- https://www.acmicpc.net/problem/13335
- 구현(자료구조)

# 생각과정
- 예전에 큐를 써서 풀었던 문제같은데 그거보다는 비효율적일 수도 있긴 하지만 
  그냥 다리에 트럭을 한 대 더 올릴 수 있으면 해당 트럭 무게, 없으면 0 추가하는 방식으로 하고
  반복문이 시간을 의미한다고 생각하면 연산 과정 자체가 생략돼서 그렇게 풀었다
- 주의할 점은 brigde를 탈출조건으로 사용할 수 없으므로 별도로 truckCount 변수를 선언해줬다는 거?!
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

// MARK: - Solution

let n = file.readInt(), w = file.readInt(), L = file.readInt()
let trucks = file.readIntArray(n)

print(solution(trucks, w, L))

func solution(_ trucks: [Int], _ width: Int, _ load: Int) -> Int {
    let truckCount = trucks.count
    var time = 0, trucks = trucks, bridge = Array(repeating: 0, count: width), count = 0

    while count != truckCount {
        time += 1
        count += bridge.removeFirst() == 0 ? 0 : 1
        let truck = (trucks.first != nil && bridge.sum + trucks.first! <= load) ? trucks.removeFirst() : 0
        bridge.append(truck)
    }

    return time
}

extension Array where Element == Int {
    var sum: Int { reduce(0, +) }
}
