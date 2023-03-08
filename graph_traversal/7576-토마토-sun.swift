/*
 - https://www.acmicpc.net/problem/7576
 - 그래프 탐색(bfs)
 - 어휴 큐 구현 안 했더니 시간초과~
 */

import Foundation

typealias Tomato = (row: Int, col: Int, time: Int)

struct Queue<T> {
    var isEmpty: Bool { startIndex == endIndex }
    var count: Int { endIndex - startIndex }

    private var startIndex = 0
    private var endIndex = 0
    private var elements = [T]()

    mutating func enqueue(_ element: T) {
        endIndex += 1
        elements.append(element)
    }

    mutating func dequeue() -> T {
        defer { startIndex += 1 }

        return elements[startIndex]
    }
}

enum Status: Int {
    case empty = -1
    case raw
    case ripe
}

func solution(graph: [[Int]]) -> Int {
    let (queue, totalCount) = parseGraph(graph)
    return bfs(graph: graph, queue: queue, totalCount: totalCount)
}

func parseGraph(_ graph: [[Int]]) -> (Queue<Tomato>, Int) {
    var queue = Queue<Tomato>(), emptyCount = 0

    for row in 0..<graph.count {
        for col in 0..<graph[0].count {
            let position = graph[row][col]
            if position == Status.ripe.rawValue {
                queue.enqueue((row, col, 0))
            } else if position == Status.empty.rawValue {
                emptyCount += 1
            }
        }
    }

    return (queue, graph.count * graph[0].count - emptyCount)
}

func bfs(graph: [[Int]], queue: Queue<Tomato>, totalCount: Int) -> Int {
    let dir = zip([0, -1, 0, 1], [1, 0, -1, 0])
    var graph = graph, ripeCount = queue.count, queue = queue, totalTime = 0

    while !queue.isEmpty {
        let (row, col, time) = queue.dequeue()
        guard ripeCount != totalCount
        else {
            return totalTime
        }

        for (dr, dc) in dir {
            let nr = row + dr, nc = col + dc
            guard graph[safe: nr]?[safe: nc] == Status.raw.rawValue
            else {
                continue
            }

            graph[nr][nc] = Status.ripe.rawValue
            queue.enqueue((nr, nc, time + 1))
            ripeCount += 1
            totalTime = time + 1
        }
    }

    return -1
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var graph = [[Int]]()

for _ in 0..<input[1] {
    graph.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(graph: graph))
