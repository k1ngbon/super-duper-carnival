/*
 - https://www.acmicpc.net/problem/2011
 - DP
 - 진짜 드럽게 풀었는데....다른 사람들 풀이 실화냐?ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ
 - 처음부터 숫자 한 자리씩 누적해 가면서 이전 자리 숫자에 붙일 수 있는 경우랑 그냥 한자리로 바로 붙이는 경우를 계산하는 방식으로 접근함
   그래서 dp에는 마지막 자리 숫자가 뭐였는지랑 그게 몇 번 나왔는 지 기록해서 다음 자리 계산할 때 사용했다...
 - 근데...근데...다른 사람들 풀이 보니까 이거 반토막이고요ㅠ
    - 위의 논리를 좀 더 단순화하면 새로운 숫자 하나를 덧붙일 때 가능한 경우는 누적된 코드에
        1) 새로운 숫자를 단일로 추가하는 경우
        2) 직전의 마지막 숫자의 뒤에 덧붙여서 만든 두 자리 수가 1 ~ 26 사이인 경우(e.g. 2 + 1 = 21)
      이렇게 2개고 1), 2)의 경우의 수는 각각 dp[i - 1], dp[i - 2] 가 된다는 것을 도출할 수 있다
      이 점화식에 숫자가 0일 때의 예외처리를 추가하면 끝...
      자세한 코드는 betterSolution() 함수 참고

 // MARK: - 교훈
 - 정답이 크니까 % divider 를 리턴하라고 하는 경우에 연산 중에도 넘치는 거 막기 위해서
   정답에 영향 없는 경우에는 연산 중에도 % divider 계속 해 주면 런타임 에러 방지 가능~
    - 이 문제의 경우 마지막에 reduce 할 때도 % divider 해줘야 됐는데 안 해줘서 실패 스택 하나 더 쌓음~
 - 코드 짤 게 좀 많은 데 싶으면 조금만 더...생각해보자...
*/

import Foundation

func solution(number: String) -> Int {
    let codes = number.compactMap { Int(String($0)) }, count = codes.count
    let validRange = 1...26, divider = 1000000
    var dp = Array(repeating: [Int: Int](), count: count)

    guard !codes.isEmpty, codes[0] != 0
    else {
        return 0
    }

    dp[0][codes[0]] = 1

    for index in 1..<count {
        let code = codes[index]

        if code == 0 {
            var isDecodable = false

            for (last, count) in dp[index - 1] {
                let sum = 10 * last + code
                guard validRange ~= sum
                else {
                    continue
                }

                dp[index][sum] = ((dp[index][sum] ?? 0) + count) % divider
                isDecodable = true
            }

            if !isDecodable {
                return 0
            }
            continue
        }

        for (last, count) in dp[index - 1] {
            dp[index][code] = ((dp[index][code] ?? 0) + count) % divider

            let sum = 10 * last + code
            guard validRange ~= sum
            else {
                continue
            }

            dp[index][sum] = ((dp[index][sum] ?? 0) + count) % divider
        }
    }

    return dp.last!.values.reduce(0, +) % divider
}

func betterSolution(number: String) -> Int {
    let codes = number.compactMap { Int(String($0)) }, count = codes.count
    let validRange = 1...26, divider = 1000000

    guard codes[0] != .zero
    else {
        return 0
    }

    var dp = [1, 1] + Array(repeating: 0, count: count - 1)

    for index in stride(from: 2, through: count, by: 1) {
        let number = codes[index - 1], last = codes[index - 2]

        if number != 0 {
            /// number를 마지막에 덧붙이는 경우는 dp[index - 1]의 각 경우의 마지막에 덧붙이면 되므로
            dp[index] += dp[index - 1] % divider
        }

        /// 마지막 숫자에 number를 붙인 값: 마지막이 2, number가 1이면 21
        let doubleDigit = last * 10 + number
        guard last != 0,  // 마지막 숫자가 0이었던 경우 항상 제외
              validRange ~= doubleDigit
        else {
            continue
        }

        /// doubleDigit을 덧붙일 수 있는 경우의 수는 마지막 숫자가 포함되기 전의 dp값인 dp[index - 2]의 각 경우에 doubleDigit을 덧붙이는 것이므로
        dp[index] += dp[index - 2] % divider
    }

    return dp.last! % divider
}

print(betterSolution(number: readLine()!))

