/*
- https://www.acmicpc.net/problem/5427
- 그래프탐색(bfs)

# 생각과정
- 시작점이 여러 개인 bfs네...불 따로 플레이어 따로 돌려야되나? 
- 처음에 시작할 때 큐에 불 위치부터 넣고 마지막에 플레이어 넣으면 한 번에 될 듯!
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

struct Queue<T> {

    var isEmpty: Bool { startIndex == endIndex }
    private var elements: [T]
    private var startIndex = 0
    private var endIndex: Int { elements.endIndex }

    init(_ elements: [T] = []) {
        self.elements = elements
    }

    func print() {
        Swift.print((startIndex..<endIndex).map { elements[$0] })
    }

    mutating func push(_ element: T) {
        elements.append(element)
    }

    mutating func pop() -> T? {
        if isEmpty { return nil }

        defer { startIndex += 1 }
        return elements[startIndex]
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

var answer = [String]()

for _ in 0..<file.readInt() {
    file.readInt()
    answer.append(solution(file.readStringArray(file.readInt())))
}

print(answer.joined(separator: "\n"))

typealias Graph = [[String]]
typealias Info = (isFire: Bool, r: Int, c: Int, time: Int)


func solution(_ graph: [String]) -> String {
    let empty = ".", start = "@", fire = "*"
    let dir = [(0, 1), (0, -1), (1, 0), (-1, 0)], visited = "v"
    var graph = graph.map { $0.map { String($0) }}
    let info = parse(graph), escape = (r: [0, graph.count - 1], c: [0, graph[0].count - 1])
    graph[info.last!.r][info.last!.c] = visited
    var queue = Queue(info)

    func parse(_ graph: Graph) -> [Info] {
        var player = Info(false, 0, 0, 0)
        var fires = [Info]()

        for r in 0..<graph.count {
            for c in 0..<graph[0].count {
                let value = graph[r][c]
                if value == fire {
                    fires.append((true, r, c, 0))
                } else if value == start {
                    player = (false, r, c, 0)
                }
            }
        }

        return fires + [player]
    }

    func spreadFire(_ info: Info) {
        for (dr, dc) in dir {
            let nr = info.r + dr, nc = info.c + dc
            let value = graph[safe: nr]?[safe: nc]
            guard value == empty || value == visited
            else {
                continue
            }

            graph[nr][nc] = fire
            queue.push((true, nr, nc, info.time + 1))
        }
    }

    func bfs(_ info: Info) {
        for (dr, dc) in dir {
            let nr = info.r + dr, nc = info.c + dc
            let value = graph[safe: nr]?[safe: nc]
            guard value == empty
            else {
                continue
            }

            graph[nr][nc] = visited
            queue.push((false, nr, nc, info.time + 1))
        }
    }

    // 불로 인해 우회하는 경우?
    while let info = queue.pop() {
        if info.isFire {
            spreadFire(info)
        } else if escape.r.contains(info.r) || escape.c.contains(info.c) {
            return String(info.time + 1)
        } else {
            bfs(info)
        }
    }

    return "IMPOSSIBLE"
}
