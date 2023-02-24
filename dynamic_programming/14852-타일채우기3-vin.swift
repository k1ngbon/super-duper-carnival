// 수상한 문제다.... dp 배열을 N+1로 초기화할땐 런타임에러, N+2 ~ 최대값으로 했을땐 맞았습니다!!
// 수상쩍게 메모리가 엄청나게 많이 쓰인다 도대체 이게 무슨 문제야
// 한 세번 점화식 만들었는데 맞왜틀!! 반복하다가 도저히 모르겠어서 베낌

let N = Int(readLine()!)!
let divisor = 1000000007
var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: 2), count: N + 2)

dp[1][0] = 2
dp[2][0] = 7
dp[2][1] = 1

if N >= 3 {
    for i in 3...N {
        dp[i][1] = (dp[i - 3][0] + dp[i - 1][1]) % divisor
        dp[i][0] = (dp[i - 1][0] * 2 + dp[i - 2][0] * 3 + dp[i][1] * 2) % divisor
    }
}

print(dp[N][0] % divisor)

