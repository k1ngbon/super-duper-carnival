// TODO: - 2011: 암호코드
 
let word = readLine()!
let numbers = word.map { Int(String($0))! }
let count = numbers.count
let MAX = 1000000
var isValid = true

// i번째 숫자로 만들 수 있는 최대 조합
var dp: [Int] = Array(repeating: 0, count: 5002)

if numbers.first! == 0 {
    // 0으로 시작하면 해석할 수 없으므로 0 출력
    print(0)
} else {
    // 0번째 숫자로 만들 수 있는 조합은 0이지만 dp 계산을 위해 1로 초기화
    dp[0] = 1
    
    // 첫번째 숫자로 만들 수 있는 최대 조합은 1(자기 자신)
    dp[1] = 1
    
    if count >= 2 {
        for i in 2...count {
            let index = i - 1
            let currentNumber = numbers[index]
            let previousNumber = numbers[index - 1]
            
            // 현재 숫자가 0일 때, 바로 앞 숫자가 1 or 2면 두 자리만! 가능, 그 이상 또는 0이면 invalid
            // 현재 숫자가 1~6일 때, 바로 앞 숫자가 1 or 2이면 두 자리도 가능, 그 이상 또는 0이면 한 자리만 가능
            // 현재 숫자가 7~9일 때, 바로 앞 숫자가 1이면 두 자리도 가능, 그 이상 또는 0이면 관계 없이 한 자리만 가능
            
            switch currentNumber {
            case 0:
                if previousNumber == 1 || previousNumber == 2 {
                    // 10 or 20만 가능하므로 그 이전 개수와 동일
                    dp[i] = dp[i - 2] % MAX
                } else {
                    // INVALID
                    isValid = false
                    break
                }
            case 1...6:
                if previousNumber == 1 || previousNumber == 2 {
                    // 11 ~ 26이 가능하므로 이전하고 그 이전 개수의 합과 동일
                    dp[i] = (dp[i - 1] + dp[i - 2]) % MAX
                } else {
                    // 1 ~ 6 가능
                    dp[i] = dp[i - 1] % MAX
                }
            case 7...9:
                if previousNumber == 1 {
                    // 17 ~ 19 가능
                    dp[i] = (dp[i - 1] + dp[i - 2]) % MAX
                } else {
                    // 7 ~ 9 가능
                    dp[i] = dp[i - 1] % MAX
                }
            default:
                // INVALID
                isValid = false
                break
            }
        }
        print(isValid ? dp[count] : 0)
    } else {
        print(dp[1])
    }
}
