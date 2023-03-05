/*
 - https://www.acmicpc.net/problem/18430
 - 백트래킹(dfs)
 - 자잘한 실수 고치느라 시간 뚝딱..어케 해야 이런 실수를 줄이고 + 빨리 찾을 수 있을까...?
    - 양 옆 날개는 nil이 아닌 지 확인했는데 가운데는 확인을 안해서 1차로 틀렸다..
    - 그러고 나서는 첨에는 3n번째 줄이 없었는데 그러니까 for문을 스킵하는 좌표의 경우 최댓값이 제대로 업데이트 되지 않고 있었음..
      이거는 찾는데 오래걸렸다... 
 */

import Foundation

typealias Coordinate = (row: Int, col: Int)

func solution(graph: [[Int]]) -> Int {
    var answer = 0

    for row in 0..<graph.count {
        for col in 0..<graph[0].count {
            answer = max(answer, dfs(graph: graph, center: (row, col)))
        }
    }

    return answer
}

func dfs(graph: [[Int?]], center: Coordinate) -> Int {
    var maxStrength = 0

    // 1. find possible bommerangs in current coordinate
    for boomerang in findPossibleBoomerangs(in: graph, center: center) {

        // 2. for each boomerang, update graph
        var graph = graph, strength = graph[center.row][center.col]!
        for (row, col) in boomerang {
            strength += graph[row][col]!
            graph[row][col] = nil
        }

        maxStrength = max(maxStrength, strength)
        // 3. find next center and dfs to find max
        for row in center.row..<graph.count {
            for col in 0..<graph[0].count {
                guard row > center.row || col > center.col
                else {
                    continue
                }

                maxStrength = max(maxStrength, strength + dfs(graph: graph, center:(row, col)))
            }
        }
    }

    return maxStrength
}

func findPossibleBoomerangs(in graph: [[Int?]], center: Coordinate) -> [[Coordinate]] {
    var boomerangs = [[Coordinate]]()

    guard graph[center.row][center.col] != nil
    else {
        return boomerangs
    }


    let edges: [(Coordinate, Coordinate)] = [((0, -1), (1, 0)), ((0, -1), (-1, 0)), ((-1, 0), (0, 1)), ((1, 0), (0, 1))]

    for (first, second) in edges {
        let first: Coordinate = (first.row + center.row, first.col + center.col)
        let second: Coordinate = (second.row + center.row, second.col + center.col)

        guard graph[safe: first.row]?[safe: first.col] ?? nil != nil,
              graph[safe: second.row]?[safe: second.col] ?? nil != nil
        else {
            continue
        }

        boomerangs.append([first, center, second])
    }
    return boomerangs
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

print(solution(graph: graph))
