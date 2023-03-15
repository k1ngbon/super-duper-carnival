/*
 - https://www.acmicpc.net/problem/2447
 - 분할 정복(재귀)
 */

import Foundation

let star = "*", empty = " "

func solution(count: Int) -> [String] {
    guard count != 1
    else {
        return [star]
    }

    let dividedCount = count / 3
    let pattern = solution(count: dividedCount)
    let topAndBottom = pattern.map { String(repeating: $0, count: 3) }
    let middle = pattern.map { $0 + String(repeating: empty, count: dividedCount) + $0 }

    return topAndBottom + middle + topAndBottom
}

print(solution(count: Int(readLine()!)!).joined(separator: "\n"))
