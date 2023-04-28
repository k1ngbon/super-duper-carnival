/*
- https://www.acmicpc.net/problem/21278
- 완전탐색
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

func solution(_ N: Int, _ edges: [[Int]]) -> [Int] {
    func shortestPaths() -> [[Int]] {
        let dist = 2
        var graph = Array(repeating: Array(repeating: dist * N, count: N), count: N)
        (0..<N).forEach { graph[$0][$0] = 0 }

        for edge in edges {
            let a = edge[0] - 1, b = edge[1] - 1
            graph[a][b] = dist
            graph[b][a] = dist
        }

        for k in 0..<N {
            for i in 0..<N {
                for j in 0..<N {
                    graph[i][j] = min(graph[i][j], graph[i][k] + graph[k][j])
                }
            }
        }

        return graph
    }
    
    func sumAllPaths(_ i: Int, _ j: Int) -> Int {
        var sum = 0

        for k in 0..<N {
            sum += min(paths[i][k], paths[j][k])
        }

        return sum
    }

    let paths = shortestPaths()
    var total = Int.max, shops = [Int]()

    for i in 0..<N {
        for j in i + 1..<N {
            let sum = sumAllPaths(i, j)
            if sum < total {
                total = sum
                shops = [i + 1, j + 1]
            }
        }
    }
    
    return shops + [total]
}

let N = file.readInt(), M = file.readInt()
var edges = [[Int]]()

for _ in 0..<M {
    edges.append([file.readInt(), file.readInt()])
}

print(solution(N, edges).map { String($0) }.joined(separator: " "))
