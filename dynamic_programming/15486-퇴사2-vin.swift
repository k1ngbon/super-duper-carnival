let N = Int(readLine()!)!
var T: [Int] = [0]
var P: [Int] = [0]
var dp: [Int] = Array(repeating: 0, count: N + 2)

for _ in 1...N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    T.append(input[0])
    P.append(input[1])
}

for i in 1...N {
    if i + T[i] <= N + 1 {
        // N + 1일 안에 수행할 수 있으면 dp에 저장
        dp[i + T[i]] = max(dp[i + T[i]], dp[i] + P[i])
    }
    // 오늘 수행하거나 안하거나(다음날 수행하거나)
    dp[i + 1] = max(dp[i + 1], dp[i])
}

print(dp.max()!)
