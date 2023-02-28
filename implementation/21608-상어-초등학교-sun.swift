/*
 - https://www.acmicpc.net/problem/21608
 - 구현
 */

import Foundation

typealias Info = (id: Int, friends: Set<Int>)
let wall = 401, empty = 0

func solution(students: [Info], N: Int) -> Int {
    var graph = [Array(repeating: wall, count: N + 2)]
    graph += Array(repeating: [wall] + Array(repeating: empty, count: N) + [wall], count: N)
    graph.append(Array(repeating: wall, count: N + 2))

    for (id, friends) in students {
        findBestPosition(graph: &graph, N: N, id: id, friends: friends)
    }

    return calculateScore(graph: &graph, N: N, students: students)
}

func calculateScore(graph: inout [[Int]], N: Int, students: [Info]) -> Int {
    let students = students.sorted { $0.id < $1.id }, scores = [0, 1, 10, 100, 1000]
    var totalScore = 0

    for r in 1...N {
        for c in 1...N {
            let id = graph[r][c] - 1, friends = students[id].friends
            let (_, friendCnt) = checkNeighbors(graph: &graph, row: r, column: c, friends: friends)
            totalScore += scores[friendCnt]
        }
    }

    return totalScore
}

func findBestPosition(graph: inout [[Int]], N: Int, id: Int, friends: Set<Int>) {
    var position = (row: 0, col: 0), friendCount = -1, emptyCount = -1

    for r in 1...N {
        for c in 1...N {
            // 1. check if empty
            guard graph[r][c] == empty
            else {
                continue
            }

            // 2. check neighbors
            let neighbors = checkNeighbors(graph: &graph, row: r, column: c, friends: friends)

            guard neighbors.friends > friendCount
                    || (neighbors.friends == friendCount && neighbors.empty > emptyCount)
            else {
                continue
            }

            friendCount = neighbors.friends
            emptyCount = neighbors.empty
            position = (r, c)
        }
    }

    graph[position.row][position.col] = id
}

func checkNeighbors(graph: inout [[Int]], row: Int, column: Int, friends: Set<Int>) -> (empty: Int, friends: Int) {
    let dir = zip([1, 0, -1, 0], [0, 1, 0, -1])

    var emptyCnt = 0, friendCnt = 0

    for (dr, dc) in dir {
        let nr = row + dr, nc = column + dc, neighbor = graph[nr][nc]

        if neighbor == empty {
            emptyCnt += 1
            continue
        }

        if friends.contains(neighbor) {
            friendCnt += 1
        }
    }

    return (emptyCnt, friendCnt)
}

let N = Int(readLine()!)!
var info = [Info]()

for _ in 0..<N * N {
    var input = readLine()!.split(separator: " ").map { Int(String($0))! }
    info.append(Info(input.removeFirst(), Set(input)))
}

print(solution(students: info, N: N))
