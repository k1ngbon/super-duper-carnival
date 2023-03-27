/*
- https://school.programmers.co.kr/learn/courses/30/lessons/150365
*/

import Foundation

typealias Coordinate = (r: Int, c: Int)
typealias Step = (dr: Int, dc: Int, dir: String)

enum Path: String, CaseIterable {
    case down = "d"
    case left = "l"
    case right = "r"
    case up = "u"

    var diff: Coordinate {
        switch self {
        case .down:
            return (1, 0)
        case .left:
            return (0, -1)
        case .right:
            return (0, 1)
        case .up:
            return (-1, 0)
        }
    }
}

struct Queue<T> {
    var isEmpty: Bool { startIndex == endIndex }
    var count: Int { endIndex - startIndex }

    private var startIndex = 0
    private var endIndex: Int { self.elements.endIndex }
    private var elements = [T]()

    init(_ elements: [T]) {
        self.elements = elements
    }

    mutating func enqueue(_ element: T) {
        elements.append(element)
    }

    mutating func dequeue() -> T {
        defer { startIndex += 1 }

        return elements[startIndex]
    }
}

private let fail = "impossible"
private let dirs = Path.allCases.map { (r: $0.diff.r, c: $0.diff.c, dir: $0.rawValue) }

/// 크기(n, n), 시작(x, y), 도착(r, c), 목표 거리: k
func solution(_ n:Int, _ m:Int, _ x:Int, _ y:Int, _ r:Int, _ c:Int, _ k:Int) -> String {
    let graph = makePaddedGraph(n: n, m: m), start = (x, y), end = (r, c)
    let shortestPath = findShortestPath(graph: graph, start: start, end: end)
    guard isPossibleLength(k, shortestLength: shortestPath.count)
    else {
        return fail
    }

    return findBestFit(graph: graph, shortestPath: shortestPath, start: start, k: k)
}

func findBestFit(graph: [[Bool]], shortestPath: [Step], start: Coordinate, k: Int) -> String {
    var k = k, shortestPath = shortestPath, free = (k - shortestPath.count) / 2
    shortestPath.reverse()
    var (r, c) = start, route = "", remains = [Step]()

    while k != 0 {
        k -= 1

        if free == 0 {
            let shouldPopRemains = (remains.last?.dir ?? "z") < (shortestPath.last?.dir ?? "z")
            let (dr, dc, path) = shouldPopRemains ? remains.removeLast() : shortestPath.removeLast()
            r += dr
            c += dc
            route += path

            continue
        }

        // find best dir
        let index = dirs.firstIndex { graph[r + $0.r][c + $0.c] }!
        let (dr, dc, dir) = dirs[index]
        r += dr
        c += dc
        route += dir

        guard (dr, dc) != (shortestPath.last?.dr ?? -1, shortestPath.last?.dc ?? -1)
        else {
            _ = shortestPath.popLast()
            continue
        }

        free -= 1
        remains.append((dr * -1, dc * -1, dirs[4 - index - 1].dir))
    }

    return route
}

func isPossibleLength(_ k: Int, shortestLength: Int) -> Bool {
    k < shortestLength ? false : (k - shortestLength) % 2 == 0
}

func findShortestPath(graph: [[Bool]], start: Coordinate, end: Coordinate) -> [(Int, Int, String)] {
    var graph = graph, queue = Queue([(start.r, start.c, [Path]())])

    while !queue.isEmpty {
        let (r, c, route) = queue.dequeue()
        guard graph[r][c]
        else {
            continue
        }

        guard (r, c) != end
        else {
            return route.map { ($0.diff.r, $0.diff.c, $0.rawValue) }
        }

        graph[r][c].toggle()
        for path in Path.allCases {
            let (dr, dc) = path.diff
            queue.enqueue((r + dr, c + dc, route + [path]))
        }
    }

    return []
}

func makePaddedGraph(n: Int, m: Int) -> [[Bool]] {
    let topBottom = Array(repeating: false, count: m + 2)
    let mid = [false] + Array(repeating: true, count: m) + [false]

    return [topBottom] + (0..<n).map { _ in mid } + [topBottom]
}
