/*
 - https://www.acmicpc.net/problem/7569
 - 그래프 탐색(bfs)
 */

import Foundation

typealias Tomato = (floor: Int, row: Int, col: Int, time: Int)

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

func solution(graph: [[[Int]]]) -> Int {
    let (queue, totalCount) = parseGraph(graph)
    return bfs(graph: graph, queue: queue, totalCount: totalCount)
}

func parseGraph(_ graph: [[[Int]]]) -> (Queue<Tomato>, Int) {
    var queue = Queue<Tomato>(), emptyCount = 0

    for floor in 0..<graph.count {
        for row in 0..<graph[floor].count {
            for col in 0..<graph[floor][row].count {
                let position = graph[floor][row][col]
                if position == Status.ripe.rawValue {
                    queue.enqueue((floor, row, col, 0))
                } else if position == Status.empty.rawValue {
                    emptyCount += 1
                }
            }
        }
    }

    return (queue, graph.count * graph[0].count * graph[0][0].count - emptyCount)
}

func bfs(graph: [[[Int]]], queue: Queue<Tomato>, totalCount: Int) -> Int {
    let dr = [0, 1, 0, -1, 0, 0], dc = [1, 0, -1, 0, 0, 0], df = [0, 0, 0, 0, 1, -1]
    var graph = graph, ripeCount = queue.count, queue = queue, totalTime = 0

    while !queue.isEmpty {
        let (floor, row, col, time) = queue.dequeue()
        guard ripeCount != totalCount
        else {
            return totalTime
        }

        for index in 0..<6 {
            let nf = floor + df[index], nr = row + dr[index], nc = col + dc[index]
            guard graph[safe: nf]?[safe: nr]?[safe: nc] == Status.raw.rawValue
            else {
                continue
            }

            graph[nf][nr][nc] = Status.ripe.rawValue
            queue.enqueue((nf, nr, nc, time + 1))
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
var graph = [[[Int]]]()

for _ in 0..<input[2] {
    var floor = [[Int]]()
    for _ in 0..<input[1] {
        floor.append(readLine()!.split(separator: " ").map { Int(String($0))! })
    }
    graph.append(floor)
}

print(solution(graph: graph))
