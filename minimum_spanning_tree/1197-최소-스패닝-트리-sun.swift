/*
- https://www.acmicpc.net/problem/1197
- MST
*/

import Foundation

private func solution(_ V: Int, _ edges: [[Int]]) -> Int {
    var parents = Array(0...V)

    func findParent(of x: Int) -> Int {
        if x != parents[x] {
            parents[x] = findParent(of: parents[x])
        }

        return parents[x]
    }

    func formUnion(_ a: Int, _ b: Int) -> Bool {
        let a = findParent(of: a), b = findParent(of: b)
        if a == b { return false }

        if a < b {
            parents[b] = a
        } else {
            parents[a] = b
        }

        return true
    }

    let edges = edges.sorted { $0[2] < $1[2] }
    var total = 0

    for edge in edges {
        let a = edge[0], b = edge[1], cost = edge[2]
        total += formUnion(a, b) ? cost : 0
    }

    return total
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let V = input[0], E = input[1]
var edges = [[Int]]()

for _ in 0..<E {
    edges.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(V, edges))
