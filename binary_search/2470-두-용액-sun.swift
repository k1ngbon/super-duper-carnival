/*
 - https://www.acmicpc.net/problem/2470
 - 이분탐색이라는데 투포인터로 풀음
 */

import Foundation

func solution(liquids: [Int]) -> [Int] {
    let liquids = liquids.sorted()
    var start = 0, end = liquids.endIndex - 1, bestSum = 1_000_000_000 * 2 + 1
    var answer = [Int]()

    while start < end {
        let sum = liquids[start] + liquids[end]

        if abs(sum) < bestSum {
            bestSum = abs(sum)
            answer = [start, end]
        }

        if sum < 0 {
            start += 1
        } else {
            end -= 1
        }
    }

    return answer.map { liquids[$0] }
}

readLine()!
print(solution(liquids: readLine()!.split(separator: " ").map { Int(String($0))! })
        .map { $0.description }
        .joined(separator: " ")
)
