/*
- https://school.programmers.co.kr/learn/courses/30/lessons/161988
- 누적합, DP
- 입출력 없으니까 살 것 같다 ㅎ
- 부분 수열의 합을 구하는 거라서 누적합이 아닐까 하고 생각했음 각각의 펄스 수열로 누적합을 구하고 
  이걸 써서 최대합을 구하면 되지 않을까 했는데 최대합 구하는 걸 어떻게 단축할까가 고민이었다... 
- 처음부터 순회하면서 현재 값 - 가장 작은 값을 해서 최대합과 가장 작은 값을 각각 계속 갱신하면 O(n)으로 가능한~
- 누적합의 첫번째 값이 답인 경우를 대비해서 단순 min() - max()를 하면 안된다고 생각했는데 
  다른 사람 풀이 보니까 누적합 배열 맨 앞에 0을 추가하는 방식으로 아주 간단하게 해결했다.
  이렇게 하면 음수/양수 펄스 수열도 따로 고려할 필요가 없어져서 더 간단한 것 같다...
*/

import Foundation

// O(N)
func solution(_ sequence:[Int]) -> Int64 {
    let plusSum = sequence.pulseSequence(startsWithOne: true).prefixSum()
    let minusSum = sequence.pulseSequence(startsWithOne: false).prefixSum()
    var maxSum = Int.min, plusStart = 0, minusStart = 0

    for index in 0..<sequence.endIndex {
        let plusSum = plusSum[index], minusSum = minusSum[index]
        maxSum = max(maxSum, plusSum - plusStart, minusSum - minusStart)
        plusStart = plusSum < plusStart ? plusSum : plusStart
        minusStart = minusSum < minusStart ? minusSum : minusStart
    }

    return Int64(maxSum)
}

extension Array where Element == Int {

    func pulseSequence(startsWithOne: Bool) -> Self {
        var multiplier = startsWithOne ? -1 : 1
        return self.map { 
            multiplier *= -1
            return multiplier * $0
        }
    }

    func prefixSum() -> Self {
        var array = [Int]()

        for element in self {
            array.append(element + (array.last ?? 0))
        }

        return array
    }
}

