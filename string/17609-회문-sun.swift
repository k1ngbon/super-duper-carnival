/*
 - https://www.acmicpc.net/problem/17609
 - 문자열
 */

import Foundation

enum Case: Int {
    case palindrome, pseudo, neither
}

func solution(strings: [[String]]) -> [Int] {
    var answer = [Int]()

    for string in strings {
        if string.isPalindrome {
            answer.append(Case.palindrome.rawValue)
        } else if string.isPseudoPalindrome {
            answer.append(Case.pseudo.rawValue)
        } else {
            answer.append(Case.neither.rawValue)
        }
    }

    return answer
}

extension Array where Element: Equatable {
    var isPalindrome: Bool {
        var isPalindrome = true

        for index in 0..<count / 2 {
            if self[index] != self[count - index - 1] {
                isPalindrome = false
                break
            }
        }

        return isPalindrome
    }

    var isPseudoPalindrome: Bool {
        return checkIfPseudoPalindromeFromLeft() || self.reversed().checkIfPseudoPalindromeFromLeft()
    }

    private func checkIfPseudoPalindromeFromLeft() -> Bool {
        var didPass = false, sum = count - 1
        for index in 0..<count / 2 + 1 {
            // if not same, pass once else return false
            guard self[index] != self[sum - index]
            else {
                continue
            }

            if didPass {
                return false
            }

            didPass.toggle()
            sum += 1
        }

        return true
    }
}

let N = Int(readLine()!)!
var strings = [[String]]()

for _ in 0..<N {
    strings.append(readLine()!.map { String($0) })
}

solution(strings: strings).forEach { print($0) }

