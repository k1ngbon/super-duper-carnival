/*
- https://www.acmicpc.net/problem/13910
- dp

생각 과정
- dp인건 알겠는데 문제 잘못 이해해서 완전 다른 식으로 접근하다가... 
- 문제 제대로 읽었는데도 결국 이해 안 가서 답지 봤다^^ 
- 한손인지 양손인지 가리는 게 어렵다고 생각했는데 단순하게 wok 배열을 둘면서 
  1개 혹은 2개 조합으로 가능한 경우를 다 미리 체크하고 그걸 기반으로 DP를 돌리면 됐다
- 그리고 dp를 갱신할 때는 가능한 모든 조합을 확인하기...!

*/

private func solution(_ orderCount: Int, _ woks: [Int]) -> Int {
    var dp = parse(orderCount, woks)

    for order in stride(from: 1, through: orderCount, by: 1) {
        for index in stride(from: 1, through: order / 2, by: 1) {
            if dp[index] != .max, dp[order - index] != .max {
                dp[order] = min(dp[order], dp[index] + dp[order - index])
            }
        }
    }

    return dp[orderCount] == .max ? -1 : dp[orderCount]
}

private func parse(_ orderCount: Int, _ woks: [Int]) -> [Int] {
    var dp = Array(repeating: Int.max, count: 20_001)

    for index in 0..<woks.count {
        let wok = woks[index]
        dp[wok] = 1

        for next in index + 1..<woks.count {
            dp[wok + woks[next]] = 1
        }
    }

    return dp
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let woks = readLine()!.split(separator: " ").map { Int(String($0))! }
print(solution(input[0], woks))
