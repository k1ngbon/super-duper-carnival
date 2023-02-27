/*
 - https://www.acmicpc.net/problem/2212
 - 그리디
 - 17줄..런타임 에러를 조심하자...
*/

import Foundation

func solution(N: Int, K: Int, sensors: [Int]) -> Int {
    let sensors = sensors.sorted()
    var diff = [Int]()

    for index in 1..<N {
        diff.append(sensors[index] - sensors[index - 1])
    }

    return diff.sorted().reversed().suffix(max(0, N - K)).reduce(0, +)
}

let N = Int(readLine()!)!, K = Int(readLine()!)!
let sensors = readLine()!.split(separator: " ").map { Int(String($0))! }

print(solution(N: N, K: K, sensors: sensors))
