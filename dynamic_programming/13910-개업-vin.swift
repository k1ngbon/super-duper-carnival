// MARK: - 13910: 개업

// 대충 풀었을 때 미친 인덱스 에러 난 테케)
// 2 2
// 3 4
// output: -1

// N, M
let firstInput: [Int] = readLine()!.split(separator: " ").map { Int(String($0))! }
let (N, M) = (firstInput[0], firstInput[1])

// 웍 사이즈
let size: [Int] = readLine()!.split(separator: " ").map { Int(String($0))! }

// i개의 짜장면 만드는데 드는 최소 횟수
var dp: [Int] = Array(repeating: Int.max, count: N + 2)

// 1개 또는 2개 웍으로 한번 만들 수 있는 횟수
for i in 0..<size.count {
    let firstWok = size[i]
    
    // 웍이 너무 크면 아예 못 만듦
    if firstWok > N { continue }
    
    dp[firstWok] = 1
    
    for j in (i + 1)..<size.count {
        let secondWok = size[j]
        
        // 웍이 너무 크면 아예 못 만듦
        if firstWok + secondWok > N { continue }
        
        dp[firstWok + secondWok] = 1
    }
}

// n개의 짜장면 만들기 위한 최소 조합
for n in 1...N {
    
    // 1이면 이미 최소 조합 완성이므로 continue
    if dp[n] == 1 { continue }
    
    // 1부터 n/2까지 n을 만들 수 있는 수의 조합만큼 반복
    // 예) n = 5일 때, (1, 4), (2, 3)의 횟수를 보고 최소값을 dp에 저장
    if n >= 2 {
        for aNum in 1...(n / 2) {
            let bNum = n - aNum
            
            // 다 돌아서 invalid처리 된 애들은 건너뛰기
            if dp[aNum] == -1 || dp[bNum] == -1 { continue }
            
            dp[n] = min(dp[n], dp[aNum] + dp[bNum])
        }
    }
    
    // 다 돌았는데 Int.max면 invalid
    if dp[n] == Int.max { dp[n] = -1 }
}

print(dp[N])
