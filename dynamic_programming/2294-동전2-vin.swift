let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let (n, k) = (input[0], input[1])

// i에 대한 동전의 개수, 최소값 연산을 위해 Int.max로 초기화
var dp = Array(repeating: Int.max, count: k + 1)

// 0을 만들 수 있는 동전의 개수는 없으므로 0
dp[0] = 0

for _ in 1...n {
    
    let value = Int(readLine()!)!
    
    // 동전의 가치가 k보다 크면 연산필요 X
    if value > k { continue }
    
    // 동전의 가치가 k보다 작거나 같으면
    // value...k 범위 안에 있는 수에 대해 동전의 개수 추가 가능
    // dp[num - value]가 Int.max이면 만들 수 있는 동전의 개수가 없으므로 continue -> 안하면 런타임에러
    for num in value...k {
        if dp[num - value] == Int.max { continue }
        dp[num] = min(dp[num - value] + 1, dp[num])
    }
}

print(dp[k] == Int.max ? -1 : dp[k])

