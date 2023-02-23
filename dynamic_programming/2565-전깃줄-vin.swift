// MARK: - 2565: 전깃줄

// 전체 - (가장 긴 증가하는 부분 수열)의 길이

let N = Int(readLine()!)!
var pair: [[Int]] = [[0, 0]]
var dp: [Int] = Array(repeating: 0, count: 501)

// 입력 받기
for _ in 1...N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    pair.append(input)
}

// A 전봇대 순서대로 정렬
pair.sort { $0.first! < $1.first! }

// 가장 긴 증가하는 부분 수열 구하기
for i in 1...N {
    
    // i에 해당하는 위치 번호
    let n = pair[i].last!
    
    // 0부터 n까지중에 최장수열 찾아서 +1(자기자신)
    dp[n] = max(dp[n], dp[0..<n].max()!) + 1
}

print(N - dp.max()!)
