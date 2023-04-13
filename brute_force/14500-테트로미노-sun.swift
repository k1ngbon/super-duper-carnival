/*
- https://www.acmicpc.net/problem/14500
- 완전탐색
*/

import Foundation

typealias Coordinate = (r: Int, c: Int)

private let tetrominos = [
    [(0, 0), (0, 1), (0, 2), (0, 3)],
    [(0, 0), (1, 0), (2, 0), (3, 0)],

    [(0, 0), (0, 1), (1, 0), (1, 1)],

    [(0, 0), (1, 0), (2, 0), (2, 1)],
    [(0, 0), (0, 1), (1, 0), (2, 0)],
    [(0, 0), (1, 0), (0, 1), (0, 2)],
    [(0, 0), (1, 0), (1, 1), (1, 2)],
    [(0, 0), (0, 1), (1, 1), (2, 1)],
    [(0, 0), (0, 1), (-1, 1), (-2, 1)],
    [(0, 0), (0, 1), (0, 2), (-1, 2)],
    [(0, 0), (0, 1), (0, 2), (1, 2)],

    [(0, 0), (1, 0), (1, 1), (2, 1)],
    [(0, 0), (0, 1), (-1, 1), (-1, 2)],
    [(0, 0), (-1, 0), (-1, 1), (-2, 1)],
    [(0, 0), (0, 1), (1, 1), (1, 2)],

    [(0, 0), (0, 1), (0, 2), (1, 1)],
    [(0, 0), (0, 1), (-1, 1), (1, 1)],
    [(0, 0), (0, 1), (0, 2), (-1, 1)],
    [(0, 0), (1, 0), (2, 0), (1, 1)]
]

func solution(_ graph: [[Int]]) -> Int {
    var answer = 0

    func findBestSum(_ row: Int, _ col: Int) -> Int {
        var maxSum = 0
        outerLoop: for tetro in tetrominos {
            var sum = 0
            for (dr, dc) in tetro {
                guard let num = graph[safe: row + dr]?[safe: col + dc]
                else {
                    continue outerLoop
                }

                sum += num
            }

            maxSum = max(maxSum, sum)
        }

        return maxSum
    }

    for row in 0..<graph.count {
        for col in 0..<graph[0].count {
            answer = max(answer, findBestSum(row, col))
        }
    }

    return answer
}

fileprivate extension Array {
    subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var graph = [[Int]]()

for _ in 0..<input[0] {
    graph.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(graph))
