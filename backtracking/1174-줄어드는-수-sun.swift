/*
 - https://www.acmicpc.net/problem/1174
 - 백트래킹(dfs)
 - 처음에 사실 문제를 잘못 이해해서 최댓값이 무한히 늘어날 수 있다고 생각해서 예제 입력 3에서 500000을 입력하는 경우 왜 -1 인지를 이해를 못했는데
   구하는 숫자가 내림차순이어야 하기 때문에 최댓값이 9876543210이 된다....9876543210까지의 숫자 중에서 내림차순을 만족하는 경우는 더 작고
   예제 3으로부터 500000 보다도 작구나를 유추할 수 있다.
 - 결국 이 문제에서는 예제값이 힌트인데 줄어드는 수가 어차피 500000개 미만이라면 dfs를 통해서 모든 경우의 수를 다 구하고 sort해도 시간이 충분하겠다 싶어서
   완탐때렸다 ㅎ
    - 더 생각하면 효율적인 풀이가 있을 수도 있지만 걍 실수 없고 시간도 충분하니까 완탐으로 만족~
 - 다른 사람꺼 보니까 0부터 순차적으로 만들어주는 방식이었음 이게 더 빠를거 같지만...몰라...
 */

import Foundation

func solution(N: Int) -> Int {
    func dfs(numbers: [Int] = []) -> [Int] {
        var allCases = [Int]()

        for next in stride(from: (numbers.last ?? -1) + 1, through: 9, by: 1) {
            let numbers = numbers + [next]
            allCases.append(numbers.int())
            allCases += dfs(numbers: numbers)
        }

        return allCases
    }

    let descendingNumbers = dfs().sorted()

    return N <= descendingNumbers.endIndex ? descendingNumbers[N - 1] : -1
}

extension Array where Element == Int {
    func int() -> Int {
        reversed().reduce(0) { 10 * $0 + $1 }
    }
}


print(solution(N: Int(readLine()!)!))

