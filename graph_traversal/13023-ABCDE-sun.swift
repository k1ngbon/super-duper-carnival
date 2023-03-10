/*
 - https://www.acmicpc.net/problem/13023
 - 그래프 탐색(dfs)
 - 처음에 그냥 stack으로 dfs했는데 visited가 독립적으로 유지되어야 해서 재귀로 해야되는 문제였음...
 - 최악의 경우 시간 초과하지 않을까 했는데 아니었다...
 */

import Foundation

func solution(edges: [[Int]], N: Int) -> Bool {
    var graph = Array(repeating: [Int](), count: N), visited = Array(repeating: false, count: N)
    edges.forEach {
        let a = $0[0], b = $0[1]
        graph[a].append(b)
        graph[b].append(a)
    }

    func dfs(turn: Int, node: Int) -> Bool {
        guard !visited[node]
        else {
            return false
        }

        if turn == 5 {
            return true
        }

        visited[node].toggle()

        for next in graph[node] {
            if dfs(turn: turn + 1, node: next) {
                return true
            }
        }

        visited[node].toggle()
        return false
    }

    for start in 0..<N {
        if dfs(turn: 1, node: start) {
            return true
        }
    }
    return false
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var edges = [[Int]]()

for _ in 0..<input[1] {
    edges.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(edges: edges, N: input[0]) ? 1 : 0)
