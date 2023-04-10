/*
- https://www.acmicpc.net/problem/2636
- 그래프 탐색

생각 과정
- 처음에 단순 dfs로 잘못 이해헀다가 틀렸습니다의 철퇴를 맞고 보니 테두리 탐색이었다... 
- 테두리 어케 구하지 하다가 여기 문제에서는 애초에 그래프가 패딩되어있으므로 그냥 매 기마다 (0, 0)에서 dfs하면 구할 수 있음~

기타
- >>> 테두리를 구하라고 하면 <<< 항상 전체 그래프를 0으로 패딩한 다음에 (0, 0)이나 임의의 패딩한 점에서 시작해서 dfs/bfs 하면 됨!!!!
*/

private let air = 0, cheese = 1

private func solution(_ graph: [[Int]]) -> [Int] {
    var graph = graph, count = graph.reduce(0) { $0 + $1.reduce(0, +) }
    var time = 0, prevCount = 0
    while count != 0 {
        time += 1
        prevCount = count
        for position in findEdges(in: graph) {
            graph[position[0]][position[1]] = air
            count -= 1
        }
    }

    return [time, prevCount]
}

private func findEdges(in graph: [[Int]]) -> Set<[Int]> {
    var stack = [[0, 0]], edges = Set([[Int]]()), visited = graph
    let dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]

    while let position = stack.popLast() {
        let row = position[0], col = position[1]
        guard visited[row][col] == air
        else {
            if graph[row][col] == cheese {
                edges.insert([row, col])
            }
            continue
        }

        visited[row][col] = -1
        for (dr, dc) in dirs {
            let nr = row + dr, nc = col + dc
            guard 0..<graph.count ~= nr, 0..<graph[0].count ~= nc
            else {
                continue
            }

            stack.append([nr, nc])
        }
    }

    return edges
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var graph = [[Int]]()

for _ in 0..<input[0] {
    graph.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

solution(graph).forEach { print($0) }
