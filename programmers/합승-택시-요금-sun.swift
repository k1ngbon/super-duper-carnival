/*
- https://school.programmers.co.kr/learn/courses/30/lessons/72413#
- 플로이드 워셜

생각 과정
- 최저 비용 간선이니까 MST로 할 수 있을까? -> 반례 발견... 
- MST로는 안되는데 그럼 최저 비용은 어떻게 구할 수 있을까...?
- 임의의 점 dup까지 합승하고 dup에서는 각자 a, b로 간다고 하면 
  distance[s][dup] + distance[dup][a] + distance[dup][b]가 최소인 지점 dup을 거치는 게 최적..!
  n개의 각 점이 dup이 되는 경우를 모두 비교해서 구하면 아예 탑승을 안 하는 경우나 a, b 중 한 곳을 아예 거치는 경우도 고려됨
- 그럼 이제 각각의 거리를 구해야되는데 n이 200 이하니까 플로이드 워셜로 해도 효율성 통과할  듯 

기타 
- 처음에 impossible 값을 너무 작게 설정해서 틀림...^^... 
*/

import Foundation

private let impossible = 100_000 * 200

func solution(_ n:Int, _ s:Int, _ a:Int, _ b:Int, _ fares:[[Int]]) -> Int {
    let graph = findShortestPaths(n: n, fares: fares)
    let a = a - 1, b = b - 1, s = s - 1
    
    var minCost = graph[s][a] + graph[s][b]
    
    for dup in 0..<n {
        minCost = min(graph[s][dup] + graph[dup][a] + graph[dup][b], minCost)
    }
    
    
    return minCost
}

func findShortestPaths(n: Int, fares: [[Int]]) -> [[Int]] {
    var graph = Array(repeating: Array(repeating: impossible, count: n), count: n)
    (0..<n).forEach { graph[$0][$0] = 0 }
    for fare in fares {
        let (a, b, cost) = (fare[0] - 1, fare[1] - 1, fare[2])
        graph[a][b] = cost
        graph[b][a] = cost
    }
    
    for k in 0..<n {
        for i in 0..<n {
            for j in 0..<n {
                graph[i][j] = min(graph[i][j], graph[i][k] + graph[k][j])
            }
        }
    }

    return graph
}
