/*
 - https://www.acmicpc.net/problem/1477
 - 이분탐색
 */

import Foundation

private func solution(_ stops: [Int], M: Int, L: Int) -> Int {
    let stops = stops.sorted() + [L]
    var lo = 1, hi = 1000

    while lo <= hi {
        let mid = (lo + hi) / 2
        if isPossibleDistance(in: stops, distance: mid, M: M) {
            hi = mid - 1
        } else {
            lo = mid + 1
        }
    }

    return lo
}

private func isPossibleDistance(in stops: [Int], distance: Int, M: Int) -> Bool {
    var last = 0, newCount = 0

    for stop in stops {
        while stop - last > distance {
            if newCount == M {
                return false
            }

            newCount += 1
            last += distance
        }

        last = stop
    }

    return true
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let stops = readLine()!.split(separator: " ").map { Int(String($0))! }

print(solution(stops, M: input[1], L: input[2]))
