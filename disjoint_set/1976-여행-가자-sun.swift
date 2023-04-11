/*
- https://www.acmicpc.net/problem/1976
- 분리집합

기타
- 사실 입력값 크기 보고 플로이드워셜로도 될 것 같아서 그렇게 풀었음
  근데 주의할 점은 입력 graph는 graph[i][i] = 0 인데 자기 자신은 항상 갈 수 있으니까 1로 초기화해줘야 함
  이걸 놓쳐서...한 번 틀렸다...
*/

import Foundation

private func solution(_ graph: [[Int]], _ plans: [Int]) -> Bool {
    let plans = plans.map { $0 - 1 }, count = graph.count
    var parents = Array(0..<count)

    func findParent(of node: Int) -> Int {
        if node != parents[node] {
            parents[node] = findParent(of: parents[node])
        }

        return parents[node]
    }

    func union(_ a: Int, _ b: Int) {
        let a = findParent(of: a), b = findParent(of: b)
        if a < b {
            parents[b] = a
        } else {
            parents[a] = b
        }
    }

    for a in 0..<count {
        for b in a + 1..<count {
            if graph[a][b] == 1 {
                union(a, b)
            }
        }
    }

    return Set(plans.map { findParent(of: $0) }).count == 1
}

let N = Int(readLine()!)!
let _ = Int(readLine()!)!

var graph = [[Int]]()
for _ in 0..<N {
    graph.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

let plans = readLine()!.split(separator: " ").map { Int(String($0))! }

print(solution(graph, plans) ? "YES" : "NO")
