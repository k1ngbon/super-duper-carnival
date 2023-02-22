/*
 - https://www.acmicpc.net/problem/1106
 - DP
 - C, N의 최댓값이 각각 1000, 20 밖에 안돼서 그냥 1...C까지 순차적으로 직전까지의 정보를 활용해서 최소 비용을 구했다.
   N이 20이니까 현재 목표 인원을 달성하기 위해 최소 비용이 드는 경우를 N개 다 돌면서 매버 확인하는 방식인데
   시간 복잡도가 O(C*N)이 되고 1000 * 20 은 별로 안 크니까...
 - 근데 다른 사람 풀이 보니까 좀 더 냅색 느낌..?으로 0...<N을 돌면서 각 (비용, 인원)을 DP에 쌓는 방식이 더 많았음...
*/

import Foundation

func solution(prices: [Int], customers: [Int], N: Int, C: Int) -> Int {
    var cost = Array(repeating: Int.max, count: C + 1)
    cost[0] = 0

    for target in 1...C {
        for index in 0..<N {
            let price = prices[index], customers = customers[index]
            let currentCost = cost[max(0, target - customers)] + price
            cost[target] = min(cost[target], currentCost)
        }
    }

    return cost[C]
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let C = input[0], N = input[1]
var prices = [Int](), customers = [Int]()

for _ in 0..<N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    prices.append(input[0])
    customers.append(input[1])
}

print(solution(prices: prices, customers: customers, N: N, C: C))

