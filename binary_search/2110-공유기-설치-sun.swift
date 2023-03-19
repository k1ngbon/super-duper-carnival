/*
 - https://www.acmicpc.net/problem/2110
 - 이분탐색(파라메트릭 서치)
 - 바보다 바보야...isPossibleMinimumDistance(_:) 메서드 마지막줄이 부등호였어야 되는데 등호로 해놓고 틀렸습니다 파티...
 */

import Foundation

func solution(positions: [Int], C: Int) -> Int {
    let positions = positions.sorted()

    func isPossibleMinimumDistance(_ distance: Int) -> Bool {
        var count = 1, lastPosition = positions[0]

        for position in positions {
            guard position - lastPosition >= distance
            else {
                continue
            }

            count += 1
            lastPosition = position
        }

        return count >= C
    }

    var lo = 1, hi = positions.last! - positions.first!

    while lo <= hi {
        let mid = (lo + hi) / 2
        if isPossibleMinimumDistance(mid) {
            lo = mid + 1
        } else {
            hi = mid - 1
        }
    }

    return hi
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let N = input[0], C = input[1]
var positions = [Int]()

for _ in 0..<N {
    positions.append(Int(readLine()!)!)
}

print(solution(positions: positions, C: C))
