let firstLine = readLine()!.split(separator: " ").map { Int(String($0))! }
let (C, N) = (firstLine[0], firstLine[1])

// i명에 홍보하기위한 비용
var dp: [Int] = Array(repeating: C * 100, count: C + 101)

// 0명에 홍보할 땐 0
dp[0] = 0

for _ in 1...N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    let (price, count) = (input[0], input[1])
    
    // count부터 최대 인원까지 모두 탐색
    for n in count...C + 100 {
        dp[n] = min(dp[n - count] + price, dp[n])
    }
}

// C명부터 C + 100명까지 홍보비용중에 최소
// C명이 아닌 이유: 적어도 C명 중, 최소값을 구하는 것이므로 C + a에서 최소값이 나올 수 있음
print(dp[C...C + 100].min()!)
