/*
- https://www.acmicpc.net/problem/15683
- 구현(완전 탐색)

# 생각과정
- 완탐으로 구현했는데 다른 사람들 풀이 시간 보니까 훨씬 빨라서 내일 개선해야 될 듯...ㅎ 
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

let r = file.readInt(), c = file.readInt()
var graph = Graph()

for _ in 0..<r {
    graph.append(file.readIntArray(c))
}

print(solution(graph))


// MARK: - Solution

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

typealias Graph = [[Int]]
typealias Coordinate = (row: Int, col: Int)

enum Direction: Int, CaseIterable {
    case up, right, down, left

    var coordinate: Coordinate {
        switch self {
        case .up:
            return (-1, 0)
        case .down:
            return (1, 0)
        case .left:
            return (0, -1)
        case .right:
            return (0, 1)
        }
    }
}

struct CCTV {

    private static let allDirections: [[[Coordinate]]] = [
        (0..<4).map { [Direction(rawValue: $0)!.coordinate] },
        (0..<4).map {
            let opposite = $0 % 2 == 0 ? 2 - $0 : 4 - $0
            return [Direction(rawValue: $0)!.coordinate, Direction(rawValue: opposite)!.coordinate ]
        },
        (0..<4).map { [Direction(rawValue: $0)!.coordinate, Direction(rawValue: ($0 + 1) % 4)!.coordinate] },
        (0..<4).map { filter in Direction.allCases.compactMap { $0.rawValue == filter ? nil : $0.coordinate } },
        (0..<4).map { _ in Direction.allCases.map { $0.coordinate } }
    ]

    let coordinate: Coordinate
    let directions: [Coordinate]

    init(coordinate: Coordinate, type: Int, dirType: Int) {
        self.coordinate = coordinate
        directions = CCTV.allDirections[type - 1][dirType]
    }

    init(coordinate: Coordinate, directions: [Coordinate]) {
        self.coordinate = coordinate
        self.directions = directions
    }
}

func solution(_ graph: Graph) -> Int {
    var answer = Int.max
    let cctv = parse(graph)

    func combinations(_ elements: [Int]) {
        guard elements.count != cctv.count
        else {
            let cctvs: [CCTV] = (0..<cctv.count).map {
                let coordinate = cctv[$0]
                return CCTV(coordinate: coordinate, type: graph[coordinate.row][coordinate.col], dirType: elements[$0])
            }
            answer = min(numberOfBlindSpots(in: graph, cctvs: cctvs), answer)
            return
        }

        for index in 0..<4 {
            combinations(elements + [index])
        }
    }

    combinations([])
    return answer
}

func parse(_ graph: Graph) -> [Coordinate] {
    var coordinates = [Coordinate]()
    let wall = 6

    for row in 0..<graph.count {
        for col in 0..<graph[0].count {
            guard 1..<wall ~= graph[row][col]
            else {
                continue
            }

            coordinates.append((row, col))
        }
    }

    return coordinates
}

private func numberOfBlindSpots(in graph: Graph, cctvs: [CCTV]) -> Int {
    let empty = 0, wall = 6, visited = -1
    var graph = graph

    for cctv in cctvs {
        var stack = [cctv]

        while let cctv = stack.popLast() {
            let row = cctv.coordinate.row, col = cctv.coordinate.col, dirs = cctv.directions
            if graph[row][col] == empty { graph[row][col] = visited }

            for (dr, dc) in dirs {
                let nr = row + dr, nc = col + dc
                guard (graph[safe: nr]?[safe: nc] ?? wall != wall)
                else {
                    continue
                }

                stack.append(CCTV(coordinate: (nr, nc), directions: [(dr, dc)]))
            }
        }
    }

    let count = graph.reduce(0) { $0 + $1.filter { $0 == empty }.count }
    return count
}
