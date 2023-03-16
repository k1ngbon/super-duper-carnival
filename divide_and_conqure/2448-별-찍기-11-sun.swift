/*
 - https://www.acmicpc.net/problem/2448
 - 분할정복(재귀)
 */

import Foundation

let empty = " "
func solution(count: Int) -> [String] {
    guard count != 3
    else {
        return ["  *  ", " * * ", "*****"]
    }

    let dividedCount = count / 2, padding = String(repeating: empty, count: dividedCount)
    let pattern = solution(count: dividedCount)
    let top = pattern.map { padding + $0 + padding }
    let bottom = pattern.map { $0 + empty + $0 }

    return top + bottom
}

print(solution(count: Int(readLine()!)!).joined(separator: "\n"))
