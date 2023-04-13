/*
- https://www.acmicpc.net/problem/9251
- dp

생각과정
- LCS 사용할 수 있을 줄 알았으나 아니었고...솔루션 보니까 2차원 배열로 접근하면 되는 문제였음... 
- 점화식..점화식을 세우자...
*/

import Foundation

typealias Info = (alpha: String, index: Int)

func solution(_ a: String, _ b: String) -> Int {
    let a = [""] + a.map { String($0) }, b = [""] + b.map { String($0) }
    var graph = Array(repeating: Array(repeating: 0, count: a.count), count: b.count)

    for bIndex in 1..<b.count {
        for aIndex in 1..<a.count {
            if b[bIndex] == a[aIndex ] {
                graph[bIndex][aIndex] = graph[bIndex - 1][aIndex - 1] + 1
            } else {
                graph[bIndex][aIndex] = max(graph[bIndex][aIndex - 1], graph[bIndex - 1][aIndex])
            }
        }
    }

    return graph[b.count - 1][a.count - 1]
}

print(solution(readLine()!, readLine()!))
