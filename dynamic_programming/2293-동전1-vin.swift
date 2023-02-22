let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let (n, k) = (input[0], input[1])

// i에 대한 경우의 수
var dp = Array(repeating: 0, count: k + 1)

// 0을 만들 수 있는 경우의 수는 없으나 점화식 연산을 위해 초기화
dp[0] = 1

for _ in 1...n {
    
    let value = Int(readLine()!)!
    
    // 동전의 가치가 k보다 크면 연산필요 X
    if value > k { continue }
    
    // 동전의 가치가 k보다 작거나 같으면
    // value...k 범위 안에 있는 수에 대해 경우의 수 추가 가능
    // Int.max 범위 초과시 오버플로우 처리해주기 -> 런타임에러
    // 오버플로우 연산자 &+, &-, &*
    for num in value...k {
        dp[num] = dp[num] &+ dp[num - value]
    }
}

print(dp[k])
