/*
 - https://www.acmicpc.net/problem/16987
 - 백트래킹(dfs)
 - N이 8이니까 완탐으로 해도 전체 경우의 수가 (N - 1)^N 이고 각 경우 brokenCounts 연산에 O(N)이 걸리므로
   결국 시간 복잡도가 O((N - 1)^N * N) 이라고 생각해서 시간 초과는 안 나겠다 해서 완탐~
 */

import Foundation

typealias Egg = (durablity: Int, weight: Int)

func solution(eggs: [Egg]) -> Int {
    var eggs = eggs

    return dfs(eggs: &eggs, hammerIndex: 0)
}

func dfs(eggs: inout [Egg], hammerIndex: Int) -> Int {
    var brokenCounts = eggs.brokenCounts
    guard brokenCounts != eggs.count, hammerIndex != eggs.endIndex
    else {
        return brokenCounts
    }

    let hammerEgg = eggs[hammerIndex]
    guard hammerEgg.durablity > 0
    else {
        return dfs(eggs: &eggs, hammerIndex: hammerIndex + 1)
    }

    for (index, egg) in eggs.enumerated() {
        guard index != hammerIndex, egg.durablity > 0
        else {
            continue
        }

        eggs[hammerIndex].durablity -= egg.weight
        eggs[index].durablity -= hammerEgg.weight
        brokenCounts = max(brokenCounts, dfs(eggs: &eggs, hammerIndex: hammerIndex + 1))
        eggs[hammerIndex].durablity += egg.weight
        eggs[index].durablity += hammerEgg.weight
    }

    return brokenCounts
}

extension Array where Element == Egg {

    /// O(N)
    var brokenCounts: Int { filter { $0.durablity <= 0 }.count }
}

let N = Int(readLine()!)!
var eggs = [Egg]()

for _ in 0..<N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    eggs.append((input[0], input[1]))
}

print(solution(eggs: eggs))

