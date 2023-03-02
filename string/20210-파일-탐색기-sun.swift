/*
 - https://www.acmicpc.net/problem/20210
 - 문자열
 - 두더지 잡기 하나씩 하다가 조짐 ㅎ 경우의 수 따질 게 많았는데 하나씩 고칠때마다 자꾸 기존 로직은 그거에 맞게 안 고쳐서...
   무한 틀렸습니다~~~~~
   - leftZeroStripped() 메서드가 잘못된 게 문제였는데 이걸 고치면서 괜히 코드 좀 더 건드렸다가 경우의 수 누락돼서 망함~

 // MARK: - 교훈...
 - 메서드 하나하나 결과가 제대로 나오고 있는지 출력해서 확인하자...
 - 이렇게 조건이 자잘하게 많은 건 처음부터 계획을 꼼꼼하게 세우자...
 */

import Foundation

typealias StringData = (index: Int, elements: [String])

func solution(strings: [String]) -> [String] {
    parseStrings(strings)
        .sorted { $0.elements < $1.elements }
        .map { strings[$0.index] }
}

extension Array: Comparable where Element == String {

    public static func < (lhs: Array<Element>, rhs: Array<Element>) -> Bool {
        for (left, right) in zip(lhs, rhs) {
            guard left != right
            else {
                continue
            }

            let leftChar = left.first!, rightChar = right.first!

            // 1. both number
            if leftChar.isNumber && rightChar.isNumber {
                let zeroStrippedLeft = left.leftZeroStripped()
                let zeroStrippedRight = right.leftZeroStripped()

                if zeroStrippedLeft == zeroStrippedRight {
                    return zeroStrippedLeft != "0" ? left > right : right > left
                } else if zeroStrippedLeft.endIndex == zeroStrippedRight.endIndex {
                    return zeroStrippedLeft < zeroStrippedRight
                } else {
                    return zeroStrippedLeft.endIndex < zeroStrippedRight.endIndex
                }
            }

            guard (leftChar.isLowercase && rightChar.isUppercase)
                    || (leftChar.isUppercase && rightChar.isLowercase)
            else {
                // 2. number, letter or same case letters
                return left < right
            }

            // 3. diff case letters
            let leftLower = leftChar.lowercased(), rightLower = rightChar.lowercased()
            return leftLower == rightLower ? leftChar.isUppercase : leftLower < rightLower
        }

        return lhs.endIndex < rhs.endIndex
    }
}

extension String {

    func leftZeroStripped() -> String {
        var startIndex: String.Index = self.startIndex
        for index in indices {
            guard self[index] == "0"
            else {
                break
            }

            startIndex = self.index(after: index)
        }

        return startIndex == endIndex ? "0" : String(suffix(from: startIndex))
    }
}

func parseStrings(_ strings: [String]) -> [StringData] {
    var array = [StringData]()

    for (offset, string) in strings.enumerated() {
        var elements = [String]()

        for char in string {
            let str = String(char)
            guard char.isNumber,
                  elements.last?.last?.isNumber == true
            else {
                elements.append(str)
                continue
            }

            elements[elements.endIndex - 1].append(str)
        }

        array.append((offset, elements))
    }

    return array
}

let N = Int(readLine()!)!
var strings = [String]()

for _ in 0..<N {
    strings.append(readLine()!)
}

print(solution(strings: strings).joined(separator: "\n"))
