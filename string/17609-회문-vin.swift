// 반복문
let T = Int(readLine()!)!

for _ in 1...T {
    let string = readLine()!.map { String($0) }
    var left = 0, right = string.count - 1
    var answer = 0
    
    while left <= right {
        if answer >= 2 { break }
        
        if string[left] == string[right] {
            // 같으면 다음 글자 보기
            left += 1
            right -= 1
        } else {
            // 다르면 왼쪽, 오른쪽 옮겨가며 확인하기
            let l = left, r = right
            var lAnswer = 0
            var rAnswer = 0
            
            // 왼쪽 하나 옮겨서 확인
            left += 1
            while left <= right {
                if string[left] != string[right] {
                    lAnswer = 2
                    break
                }
                left += 1
                right -= 1
            }
            
            // 오른쪽 하나 옮겨서 확인
            left = l
            right = r - 1
            while left <= right {
                if string[left] != string[right] {
                    rAnswer = 2
                    break
                }
                left += 1
                right -= 1
            }
            
            // 왼쪽, 오른쪽 중 하나라도 회문이면 유사회문
            if lAnswer == 0 || rAnswer == 0 {
                answer = 1
                break
            } else {
                answer = 2
            }
        }
    }
    
    print(answer)
}


// 재귀로 했을 때 시간초과
func isPalindromeOrNot(of string: [String], left: Int, right: Int, _ count: Int) -> Int {
    if left >= right {
        return count
    }

    if string[left] != string[right] {
        let newLeftCount = isPalindromeOrNot(of: string, left: left + 1, right: right, count)
        let newRightCount = isPalindromeOrNot(of: string, left: left, right: right - 1, count)

        if newLeftCount == 0 || newRightCount == 0 {
            return 1
        } else {
            return 2
        }
    }
    else {
        return isPalindromeOrNot(of: string, left: left + 1, right: right - 1, count)
    }
}

let T = Int(readLine()!)!

for _ in 1...T {
    let string = readLine()!.map { String($0) }
    print(isPalindromeOrNot(of: string, left: 0, right: string.count - 1, 0))
}

