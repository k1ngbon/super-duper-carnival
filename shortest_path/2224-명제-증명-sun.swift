/*
- https://www.acmicpc.net/problem/2224
- 최단 거리(플로이드 워셜)

기타
- 알파벳은 걍 써서 하자...
*/

import Foundation

private func solution(_ statements: [[String]]) -> [[String]] {
    var dict = [String: Int]()
    let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }
    let alphabets = upper + upper.map { String(Character($0).lowercased()) }
    let count = alphabets.count
    alphabets.enumerated().forEach { dict[$0.element] = $0.offset }
    var graph = Array(repeating: Array(repeating: false, count: count), count: count)

    for statement in statements {
        graph[dict[statement[0]]!][dict[statement[1]]!] = true
    }

    for k in 0..<count {
        for i in 0..<count {
            for j in 0..<count {
                graph[i][j] = graph[i][j] || graph[i][k] && graph[k][j]
            }
        }
    }

    return (0..<count).flatMap { row in
        (0..<count).compactMap { (row != $0 && graph[row][$0]) ? [alphabets[row], alphabets[$0]] : nil }
    }
}

private let arrow = " => "
private var statements = [[String]]()
for _ in 0..<Int(readLine()!)! {
    let input = readLine()!.split(separator: " ").map { String($0) }
    statements.append([input.first!, input.last!])
}

private let answer = solution(statements)
print(answer.count)
if !answer.isEmpty {
    print(answer.map { $0.joined(separator: arrow) }.joined(separator: "\n"))
}
