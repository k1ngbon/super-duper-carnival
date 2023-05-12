/*
- https://www.acmicpc.net/problem/6198
- 자료구조(스택)

# 생각과정
- 앞에 있는 빌딩만 볼 수 있으니까 배열의 끝에서부터 스택에 넣으면서 풀면 될 것 같았음... 
- 그래서 어떤식으로 해야될까 하다가 (위치, 높이)를 스택에 집어넣되 항상 스택이 내림차순을 유지하도록 함
- 이러면 스택이 비어있으면 현재 빌딩이 제일 높으니까 위치만큼 다 볼 수 있다는 거고, 
  스택이 비어있지 않으면 현재 위치 - top의 위치 - 1 개 만큼 볼 수 있음
- 근데 다른 풀이 보니까 발상의 전환을 통해서 더 쉽게 접근할 수 있는 문제였음... 
  나는 뭔가 현재 확인 중인 빌딩을 기준으로 얘가 볼 수 있는 개수를 계산해야된다고만 생각했는데 
  그게 아니라 배열을 순서대로 돌면서 역으로 현재 확인 중인 빌딩을 볼 수 있는 다른 빌딩의 개수를 세는 것도 방법!
  이를 위해서는 스택을 내림차순으로 유지하고 스택 크기만큼 sum에 계속 더해주면 끝... 
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

// MARK: - Solution

var buildings = [Int]()

for _ in 0..<file.readInt() {
    buildings.append(file.readInt())
}

print(solution(buildings))

typealias Info = (index: Int, height: Int)

func solution(_ buildings: [Int]) -> Int {
    var front = [Info](), sum = 0

    for (index, height) in buildings.reversed().enumerated() {
        while (front.last?.height ?? .max) < height {
            front.removeLast()
        }

        sum += index - (front.last?.index ?? -1) - 1
        front.append((index, height))
    }

    return sum
}
