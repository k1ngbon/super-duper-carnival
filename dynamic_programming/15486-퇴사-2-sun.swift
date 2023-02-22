/*
 - https://www.acmicpc.net/problem/15486
 - DP
 - 예전에 퇴사 1을 풀었어서...기억이 났다...^^
*/

import Foundation

func solution(times: [Int], prices: [Int], N: Int) -> Int {
    var profits = Array(repeating: 0, count: N + 1)

    for index in stride(from: N - 1, through: 0, by: -1) {
        let time = times[index], price = prices[index]

        guard index + time <= N
        else {
            profits[index] = profits[index + 1]
            continue
        }

        profits[index] = max(profits[index + 1], price + profits[index + time])
    }

    return profits[0]
}

let N = Int(readLine()!)!
var times = [Int](), prices = [Int]()

for _ in 0..<N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    times.append(input[0])
    prices.append(input[1])
}

print(solution(times: times, prices: prices, N: N))

