/*
- https://www.acmicpc.net/problem/2225
- DP

생각 과정
- 그래프를 대체 어떤 식으로 정해야될지 엄청 오래 고민했는데 규칙을 찾다보니까 
  dp[num][k]가 숫자 nun을 k회 안에 만드는 경우의 수라고 하면
  dp[num][k] = dp[num - 1][k] + dp[num][k - 1] 이 성립한다는 것을 발견함
- 근데 dp[num][k - 1] 이거는 저 조합 개수에 마지막 한 개는 전부 0을 붙인다고 생각하면 되니까 바로 도출했는데
  dp[num - 1][k] 이거는 사실 손으로 과정 써보다가 발견했다...
  원래는 dp[num][k] = sum(dp[num][k - 1], ..., dp[0][k - 1]) 이거를 첨에 도출했는데 
  순차적으로 써보니까 결국 sum == dp[num - 1][k]였음
  전자가 num 있는 num 팀, 후자가 num 없는 num 팀이니까 이렇게 되는건가? 
*/
import Foundation

func solution(_ N: Int, _ K: Int) -> Int {
    guard K != 1 else { return 1 }

    let divider = Int(pow(10, 9.0))
    // dp[n][k] = 숫자 n을 k회 안에 만드는 경우의 수
    var dp = Array(repeating: Array(repeating: 1, count: K + 1), count: N + 1)

    for num in 1...N {
        for k in 2...K {
            dp[num][k] = (dp[num - 1][k] + dp[num][k - 1]) % divider
        }
    }

    return dp[N][K] % divider
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
print(solution(input[0], input[1]))
