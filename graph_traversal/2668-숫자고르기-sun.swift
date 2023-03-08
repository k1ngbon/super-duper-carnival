/*
 - https://www.acmicpc.net/problem/2668
 - 그래프 탐색(dfs)
 - index -> value -> index -> value 식으로 타고 타고 가서 사이클이 있으면 집합이라고 생각했음
    - 그래서 사이클을 어떻게 판별할까 하다가 key 집합이랑 value 집합을 선언하고 dfs가 끝났을 때 이 둘이 같으면 사이클!
    - 근데 좀 더 효울적으로 해보고 싶어서 생각하다가 key와 value의 교집합이 유효하다고 생각했는데 예를 들어서
      [2, 3, 2] 와 [2, 3, 3] 을 비교해보면
      1회차의 dfs 결과가 동일하게 key: (1, 2, 3), value: (2, 3)으로 교집합이 (2, 3) 인데
      전자의 경우 교집합이 실제로 조건을 만족하는 집합이지만 후자의 경우에는 만족하지 않는다...!
    - 물론 틀리고 나서 여러가지 반례 뒤져보다가 꺠달음^^
    - 이렇게 아예 풀이에서 실수한 건 또 오랜만...
 */

import Foundation

func solution(array: [Int]) -> [Int] {
    let array = [0] + array
    var answer = Set<Int>()

    for index in 1..<array.count {
        var keys = Set<Int>(), values = Set<Int>(), stack = [index]
        while let index = stack.popLast() {
            guard !keys.contains(index)
            else {
                continue
            }

            keys.insert(index)
            values.insert(array[index])
            stack.append(array[index])
        }

        if keys == values {
            answer.formUnion(keys)
        }
    }

    return answer.sorted()
}

var array = [Int]()
for _ in 0..<Int(readLine()!)! {
    array.append(Int(readLine()!)!)
}

let set = solution(array: array)
print(set.count)
set.forEach { print($0) }
