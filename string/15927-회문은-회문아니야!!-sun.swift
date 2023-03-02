/*
 - https://www.acmicpc.net/problem/15927
 - 문자열
 - 문자열의 길이가 N이라고 할 때 경우의 수가 3가지인데
    1) 팰린드롬이 아닌 경우 -> S
    2) 팰린드롬이고 하나의 문자로 구성된 경우 -> -1
    3) 팰린드롬이고 둘 이상의 문자로 구성된 경우 -> S - 1 (b/c 끝자리 하나만 자르면 되므로)
   문제에서 2) 경우 예제를 줘서 놓치는 거 없이 바로 짤 수 있었는데 만약에 테케가 없었다면 혼자 생각할 수 있었을까...?🤔
 */

import Foundation

func solution(string: String) -> Int {
    let array = string.map { String($0) }, isSingleCharacter = Set(array).count == 1

    return !array.isPalindrome ? array.count : (isSingleCharacter ? -1 : array.count - 1)
}

extension Array where Element: Equatable {
    var isPalindrome: Bool {
        for index in startIndex..<endIndex / 2 {
            if self[index] != self[endIndex - index - 1] {
                return false
            }
        }

        return true
    }
}

print(solution(string: readLine()!))
