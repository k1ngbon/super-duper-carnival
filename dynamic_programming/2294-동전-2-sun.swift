/*
 - https://www.acmicpc.net/problem/2294
 - DP
 - Int.max로 배열을 초기화할 떄는...연산 시 오버플로우가 발생할 확률이 없는지 꼭...확인하자... 
*/

import Foundation

func solution(coins: [Int], k: Int) -> Int {
    let coins = coins.filter { $0 <= k }, max = Int.max - 1
    var dp = [0] + Array(repeating: max, count: k)

    for coin in coins {
        for value in coin...k {
            dp[value] = min(dp[value], dp[value - coin] + 1)
        }
    }

    return dp[k] == max ? -1 : dp[k]
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var coins = [Int]()

for _ in 0..<input[0] {
    coins.append(Int(readLine()!)!)
}

print(solution(coins: coins, k: input[1]))

