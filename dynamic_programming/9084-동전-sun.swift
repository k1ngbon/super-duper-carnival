/*
- https://www.acmicpc.net/problem/9084
- dp 

기타
- 인덱스 실수 멈춰... 
- 점화식 꼭 써보고 구현 시작하기
*/

import Foundation

func solution(_ coins: [Int], _ M: Int) -> Int {
    let coins = [0] + coins, count = coins.count
    var dp = Array(repeating: Array(repeating: 0, count: M + 1), count: count)

    for index in 1..<count {
        let coin = coins[index]
        if coin <= M {
            dp[index][coin] = 1
        }
        
        for num in 1...M {
            dp[index][num] += dp[index - 1][num] + dp[index][max(num - coin, 0)]
        }
    }
    
    return dp.last![M]
}

var answer = [Int]()

for _ in 0..<Int(readLine()!)! {
    let _ = Int(readLine()!)!
    let coins = readLine()!.split(separator: " ").map { Int(String($0))! }
    let M = Int(readLine()!)!

    answer.append(solution(coins, M))
}

answer.forEach { print($0) }