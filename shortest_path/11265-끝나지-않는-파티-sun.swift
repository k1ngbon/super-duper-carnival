/*
 - https://www.acmicpc.net/problem/11265
 - 최단경로(플로이드-워셜)
 - 최악의 경우 연산이 1억을 넘어가서 이거 괜찮나 했는데 ㄱㅊ았다..
 - 가장 바깥 루프가 중간점이어야 되는데 청에 이걸 실수함 ㅎ
 - 제출하고 내가 젤 빨라서 엥 왜지 했는데 출력을 일일이 안하고 문자열로 바꿔서 한게 거의 100~300ms 차이났다. 
 */

import Foundation

fileprivate enum Result: String {
    case success = "Enjoy other party"
    case failure = "Stay here"
}

fileprivate func solution(graph: [[Int]], trips: [[Int]]) -> [String] {
    let graph = floydWarshall(graph)
    var results = [String]()

    for trip in trips {
        let departure = trip[0] - 1, arrival = trip[1] - 1, time = trip[2]
        results.append((graph[departure][arrival] <= time ? Result.success : .failure).rawValue)
    }

    return results
}

func floydWarshall(_ graph: [[Int]]) -> [[Int]] {
    var graph = graph

    for k in 0..<graph.count {
        for i in 0..<graph.count {
            for j in 0..<graph.count {
                graph[i][j] = min(graph[i][j], graph[i][k] + graph[k][j])
            }
        }
    }

    return graph
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var graph = [[Int]](), trips = [[Int]]()

for _ in 0..<input[0] {
    graph.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

for _ in 0..<input[1] {
    trips.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(graph: graph, trips: trips).joined(separator: "\n"))
