/*
- https://www.acmicpc.net/problem/10026

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

var graph = [String]()
for _ in 0..<file.readInt() {
    graph.append(file.readString())
}

print(solution(graph).map { String($0) }.joined(separator: " "))

func solution(_ graph: [String]) -> [Int] {
    let graph = graph.map { $0.map { String($0)} }
    let rgGraph = graph.map { $0.map { $0 == "B" ? $0 : "G"} }

    return [dfs(graph), dfs(rgGraph)]
}

private func dfs(_ graph: [[String]]) -> Int {
    var graph = graph, count = 0
    let visited = "V", dir = [(0, 1), (0, -1), (1, 0), (-1, 0)]

    for r in 0..<graph.count {
        for c in 0..<graph[0].count {
            guard graph[r][c] != visited
            else {
                continue
            }

            count += 1
            let value = graph[r][c]
            graph[r][c] = visited
            var stack = [(r, c)]

            while let (r, c) = stack.popLast() {
                for (dr, dc) in dir {
                    let nr = r + dr, nc = c + dc
                    guard graph[safe: nr]?[safe: nc] == value
                    else {
                        continue
                    }

                    graph[nr][nc] = visited
                    stack.append((nr, nc))
                }
            }
        }
    }

    return count
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
