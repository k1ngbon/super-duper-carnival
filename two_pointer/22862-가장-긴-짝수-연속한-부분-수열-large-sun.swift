/*
- https://www.acmicpc.net/problem/2141
- 투포인터
*/

import Foundation

private func solution(_ sequence: [Int], K: Int) -> Int {
    let count = sequence.count
    var start = 0, end = start, maxLength = 0, currentLength = 0, skipped = 0

    while start < count, end < count {
        if sequence[end].isEven {
            currentLength += 1
            maxLength = max(maxLength, currentLength)
            end += 1
            continue
        }
        
        if skipped != K {
            skipped += 1
            end += 1
            continue
        }

        let isEvenStart = sequence[start].isEven
        currentLength -= isEvenStart ? 1 : 0
        skipped -= isEvenStart ? 0 : 1
        start += 1
    }
    return maxLength
}

extension Int {
    var isEven: Bool { self % 2 == 0 }
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let sequence = readLine()!.split(separator: " ").map { Int(String($0))! }
print(solution(sequence, K: input[1]))
    