// MARK: - 20210: 파일 탐색기

// 무수한 틀렸습니다 !!
// 그리고 포기.

let N = Int(readLine()!)!
var arr: [[Character]] = []

for _ in 1...N {
    let str = readLine()!.map { $0 }
    arr.append(str)
}

arr.sort { fArray, sArray in
    let minCount = min(fArray.count, sArray.count)
    var i = 0
    
    while i < minCount {
        
        // first가 숫자, second가 문자 -> first가 앞에 정렬
        if fArray[i].isNumber && !sArray[i].isNumber { return true }
        
        // first가 문자, second가 숫자 -> second가 앞에 정렬
        if !fArray[i].isNumber && sArray[i].isNumber { return false }
        
        // 둘다 숫자 -> 숫자열 확인 후 앞에 0 개수 판별
        if fArray[i].isNumber && sArray[i].isNumber {
            var fNum: [Int] = [], sNum: [Int] = []
            var fIdx = i, sIdx = i
            var fZero = 0, sZero = 0
            
            // fArray의 앞 0 떼기
            while fIdx < fArray.count && fArray[fIdx] == "0" {
                fZero += 1
                fIdx += 1
            }
            
            // sArray의 앞 0 떼기
            while sIdx < sArray.count && sArray[sIdx] == "0" {
                sZero += 1
                sIdx += 1
            }
            
            // first의 숫자열 확인
            for idx in fIdx..<fArray.count {
                fIdx = idx
                if fArray[idx].isNumber { fNum.append(Int(String(fArray[idx]))!) }
                else { break }
            }
            
            // second의 숫자열 확인
            for idx in sIdx..<sArray.count {
                sIdx = idx
                if sArray[idx].isNumber { sNum.append(Int(String(sArray[idx]))!) }
                else { break }
            }
            
            // first의 유효 숫자열 길이가 더 짧음
            if fNum.count < sNum.count { return true }
            
            // second의 유효 숫자열 길이가 더 짧음
            if sNum.count < fNum.count { return false }
            
            // 두 숫자 길이가 같음 -> 숫자 대소비교
            for j in 0..<fNum.count {
                // first가 더 작음
                if fNum[j] < sNum[j] { return true }
                
                // second가 더 작음
                if sNum[j] < fNum[j] { return false }
            }
            
            // 두 숫자열이 모두 같음 -> 앞의 0 개수 비교
            if fZero < sZero { return true }
            if sZero < fZero { return false }
            
            // 두 숫자열이 모두 같고 앞의 0 개수도 모두 같으면 다음으로 넘어가기
            i = fIdx
            
            // 근데 다음으로 넘어갈 요소가 없으면 숫자로 끝난거니까 반복문 끝
            if i == minCount - 1 { break }
        }
        
        // 둘다 문자 -> 알파벳 순서로 누가 먼저인지 확인 후 대/소문자 판별
        if i < minCount && !fArray[i].isNumber && !sArray[i].isNumber {
            let fChar = fArray[i].lowercased()
            let sChar = sArray[i].lowercased()
            
            // first가 사전순 앞 -> first가 앞에 정렬
            if fChar < sChar { return true }
            
            // first가 사전순 뒤 -> second가 앞에 정렬
            if fChar > sChar { return false }
            
            // first와 second의 사전순 같음 -> 대문자가 앞에 정렬
            if fArray[i].isUppercase && sArray[i].isLowercase { return true }
            if fArray[i].isLowercase && sArray[i].isUppercase { return false }
            
            // 사전순도 같고 대소문자도 같으면 다음 인덱스로 넘기기
            i += 1
        }
    }
    
    return fArray.count < sArray.count
}

for word in arr {
    print(String(word))
}
