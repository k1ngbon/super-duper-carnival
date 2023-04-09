/*
- https://www.acmicpc.net/problem/2800
- 스택, dfs

기타
- 중복인 경우가 있을까 싶어서 따로 처리 안 해줬는데 있었음^^ "((1)) + 2" 이런 경우... 
*/

import Foundation

private let open = "(", close = ")"

private func solution(_ string: String) -> [String] {
    let array = string.map { String($0) }
    let pairs = findPairs(in: array)

    func dfs(index: Int, skip: Set<Int>, now: String) -> [String] {
        guard index != array.count
        else {
            return skip.isEmpty ? [] : [now]
        }

        if skip.contains(index) {
            return dfs(index: index + 1, skip: skip, now: now)
        }

        let str = array[index]
        var cases = dfs(index: index + 1, skip: skip, now: now + str)

        if str == open {
            cases += dfs(index: index + 1, skip: skip.union([pairs[index]!]), now: now)
        }

        return cases
    }

    return Set(dfs(index: 0, skip: [], now: "")).sorted()
}

private func findPairs(in array: [String]) -> [Int: Int] {
    var dict = [Int: Int](), stack = [Int]()

    for (index, string) in array.enumerated() {
        if string == open {
            stack.append(index)
            continue
        }

        if string == close {
            dict[stack.removeLast()] = index
        }
    }

    return dict
}

print(solution(readLine()!).joined(separator: "\n"))
