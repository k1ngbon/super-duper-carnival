// 시간초과 ~ 너무싫어~~

let T = Int(readLine()!)!

for _ in 1...T {
    let string = readLine()!.map { String($0) }
    let K = Int(readLine()!)!
    var right = 1
    var countArray: [Int] = []
    var alphaCount: [String: Int] = [:]
    
    if K == 1 {
        print("1 1")
        continue
    }
    
    // 빈도수 세기
    for s in string {
        alphaCount[s, default: 0] += 1
    }
    
    // 만들 수 없으므로 -1
    if alphaCount.values.filter({ $0 >= K }).count == 0 {
        print(-1)
        continue
    }
    
    for left in 0..<string.count {
        var kCountInRange = 1
        
        // 어차피 조건 만족 안하므로 패스
        if alphaCount[string[left]]! < K { continue }
        
        // right 시작 인덱스 초기화
        right = left + 1
        
        while right < string.count {
            if string[left] == string[right] {
                // 앞뒤가 같으면 개수 세기
                kCountInRange += 1
                
                if kCountInRange == K {
                    // 조건 만족, left 옮기기
                    countArray.append(right - left + 1)
                    break
                } else if kCountInRange < K {
                    // 알파벳 개수가 적으면 right 옮기기
                    right += 1
                } else {
                    // 알파벳 개수가 많으면 left 옮기기
                    break
                }
            } else {
                // 앞뒤가 같지 않으면 right 옮기기
                right += 1
            }
        }
    }
    
    print(countArray.isEmpty ? -1 : "\(countArray.min()!) \(countArray.max()!)")
}
