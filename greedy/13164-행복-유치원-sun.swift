/*
 - https://www.acmicpc.net/problem/13164
 - 그리디 
*/

import Foundation

func solution(N: Int, K: Int, kids: [Int]) -> Int {
    var diff = [Int]()

    for index in 1..<N {
        diff.append(kids[index] - kids[index - 1])
    }

    return diff.sorted().reversed().suffix(N - K).reduce(0, +)
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let kids = readLine()!.split(separator: " ").map { Int(String($0))! }

print(solution(N: input[0], K: input[1], kids: kids))

