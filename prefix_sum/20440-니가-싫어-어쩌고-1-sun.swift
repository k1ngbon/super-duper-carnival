// let input = readLine()!.split(separator: " ").map { Int(String($0))! }
/*
-  
*/

import Foundation

typealias Time = (start: Int, end: Int)

func solution(_ dict: [Int: Int]) -> (Int, Time) {
    var (maxStart, maxEnd) = (0, 0), maxCount = 0, currentCount = 0, hasEnd = false

    for time in dict.keys.sorted() {
        let count = dict[time]!
        if count > 0 {
            currentCount += count
            if currentCount > maxCount {
                maxStart = time
                maxCount = currentCount
            }
        } else if count < 0 {
            if currentCount == maxCount, !hasEnd {
                maxEnd = time
                hasEnd.toggle()
            }
            currentCount += count
        }
    }

    return (maxCount, (maxStart, maxEnd))
}

var dict = [Int: Int]()

for _ in 0..<Int(readLine()!)! {
    let time = readLine()!.split(separator: " ").map { Int(String($0))! }
    dict[time[0], default: 0] += 1
    dict[time[1], default: 0] -= 1
}

let (count, time) = solution(dict)
print(count)
print("\(time.start) \(time.end)")
