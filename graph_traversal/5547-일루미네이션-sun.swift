/*
 - https://www.acmicpc.net/problem/5547
 - 그래프탐색(dfs)
 - 첨에 테두리만 구하는 건 줄 모르고 잘못 생각했다가 외곽만 대체 어케 구할 지 계속 고민...
 - 그래서 반대로 빈 공간을 구하는 방법을 생각했는데 제대로 된 풀이를 생각을 못했음 ㅠ
 - 계속 일단 집 무리를 구하고 그 안에 있는 빈 공간을 세는 방법에 갇혀있다가 아무리 생각해도 그건 아닌 것 같아서
   다시 빈 공간을 활용하는 방식이 없을까 고민했다...
 - 유효한? 아무튼 집으로 갇혀있지 않은 빈 공간 집합은 결국 반드시 어느 한 곳 이상의 테두리와 접해있어야 한다는 것을 깨달음!!!
 - 그럼 테두리와 접해있는 빈 공간인지 어떻게 판별할 수 있을까 하다가 애초에 탐색을 테두리에 있는 빈 공간에서 시작하면 되겠다고 생각했음
 - 공간이 테두리에 있으면 누락되는데 그럼 애초에 배열 전체에 빈 공간을 한 번 두르고 시작하면 다 셀 수 있겠다...!
    - 특히 이렇게 하면 테두리 아무 한 점에서만 시작하면 배열 전체의 유효한 빈 공간이 다 탐색되니까 개이득
 - 근데 막상 이래놓고 방향 배열을 거꾸로 해서 또 삽질~^^
 */

import Foundation

typealias Coordinate = (row: Int, col: Int)

let empty = 0, house = 1
func solution(graph: [[Int]]) -> Int {
    countDecoratedWalls(in: paddedGrpah(graph))
}

func paddedGrpah(_ graph: [[Int]]) -> [[Int]] {
    let extra = [Array(repeating: empty, count: graph[0].count + 2)]
    let mid = graph.map { [empty] + $0 + [empty] }

    return extra + mid + extra
}

func countDecoratedWalls(in graph: [[Int]]) -> Int {
    let dirs = [
        [(-1, -1), (-1, 0), (0, -1), (0, 1), (1, -1), (1, 0)],
        [(-1, 1), (-1, 0), (0, -1), (0, 1), (1, 1), (1, 0)]
    ]
    var visited = Array(repeating: Array(repeating: false, count: graph[0].count), count: graph.count)
    var wallCount = 0, stack = [(0, 0)]

    while let (row, col) = stack.popLast() {
        guard !visited[row][col]
        else {
            continue
        }

        visited[row][col].toggle()
        for (dr, dc) in dirs[row % 2] {
            let nr = row + dr, nc = col + dc
            let space = graph[safe: nr]?[safe: nc]

            if space == empty {
                stack.append((nr, nc))
            }
            wallCount += space == house ? 1 : 0
        }
    }

    return wallCount
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
