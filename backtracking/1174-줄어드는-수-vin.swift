// MARK: - 1174: 줄어드는 수

let N = Int(readLine()!)!
var nth = 0
var answer = -1
var decliningNumbers: [Int] = []

if N >= 1024 {
    // 9876543210 초과 수는 -1임
    print(answer)
} else {
    for num in 0...9 {
        generateDecliningNumber(from: num, generated: num)
    }
    let sortedArray = decliningNumbers.sorted()
    print(sortedArray[N - 1])
}

func generateDecliningNumber(from lastNumber: Int, generated n: Int) {
    
    // 줄어드는 수 배열에 n이 없으면 추가
    if !decliningNumbers.contains(n) { decliningNumbers.append(n) }
    
    // 현재 번호보다 작은 수들 붙이기
    for num in 0..<lastNumber {
        generateDecliningNumber(from: num, generated: n * 10 + num)
    }
}
