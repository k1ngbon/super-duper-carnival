/*
 - https://www.acmicpc.net/problem/2293
 - DP
 - 순열이 아니고 조합을 구하는 경우이기 때문에 냅색 방식으로 각 동전을 순서대로 돌면서 dp에 누적하는 방식
 //MARK: - 의문인 점...
 - 계속 런타임 에러가 나서 결국 질문게시판 봤더니 dp값이 Int 범위를 초과할 수 있다고 그랬다...
   답이 2^31보다 작다는 거니까 중간에 거치는 어떤 숫자는 경우의 수가 더 많을 수도 있으니 연산 과정에서 2^31을 초과할 수 있다는 건 알겠음
 - 그래서 걍 묻고 더블로 가~ 마인드로 dp 배열을 Double 타입으로 선언해줬더니 통과했다.
 - 근데 다른 사람들 풀이 보니까 dp[value] + dp[value - coin] >= 2^31 인 경우 dp[value]를 0으로 교체하는 방식임
   기준이 대체 왜 2^31이지...?
 - 이해를 못해서 Double 대신 UInt64로도 해봤는데 이것도 또 런타임 에러 났다 대체 2^31 이거 뭐지?
*/

import Foundation

func solution(coins: [Int], k: Int) -> Int {
    let coins = coins.filter { $0 <= k }
    var dp = [1] + Array(repeating: Double.zero, count: k)

    for coin in coins {
        for value in coin...k {
            dp[value] += dp[value - coin]
        }
    }

    return Int(dp[k])
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var coins = [Int]()

for _ in 0..<input[0] {
    coins.append(Int(readLine()!)!)
}

print(solution(coins: coins, k: input[1]))

