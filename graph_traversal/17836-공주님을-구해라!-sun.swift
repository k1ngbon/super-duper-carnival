/*
 - https://www.acmicpc.net/problem/17836
 - 그래프탐색(bfs)
 - 첨에 무지성으로 우선순위 큐 쓰다가 그냥 큐로 변경
 */

import Foundation

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

typealias Turn = (row: Int, col: Int, hasGram: Bool, time: Int)

let empty = 0
let wall = 1
let gram = 2
let grammedWall = 3

func solution(graph: [[Int]], timeLimit: Int) -> String {
    let dir = [(0, 1), (0, -1), (1, 0), (-1, 0)], failed = "Fail"
    var graph = graph, queue = Queue([Turn(0, 0, false, 0)])

    while !queue.isEmpty {
        let (row, col, hasGram, time) = queue.dequeue()

        // return if destination
        if row == graph.count - 1, col == graph[0].count - 1 {
            return time <= timeLimit ? time.description : failed
        }

        guard let status = graph[safe: row]?[safe: col],
              (hasGram && status != grammedWall) || (!hasGram && status % 2 == empty)
        else {
            continue
        }

        let nowHasGram = hasGram || status == gram
        graph[row][col] = nowHasGram ? grammedWall : wall
        for (dr, dc) in dir {
            queue.enqueue((row + dr, col + dc, nowHasGram, time + 1))
        }
    }

    return failed
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var graph = [[Int]]()

for _ in 0..<input[0] {
    graph.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(graph: graph, timeLimit: input[2]))
