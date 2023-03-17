let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let (n, k) = (input[0], input[1])
var isPossible = false
var isEvenNumber = false

if n % 2 == 0 {
    // 짝수
    // left, right는 한 줄에 들어갈 수 있는 사각형의 개수
    // number는 기준 수
    
    let number = n + 2
    var right = number - 1
    var left = number / 2
    
    if k == left * left || k == right {
        isPossible = true
    } else if k > left * left || k < right {
        isPossible = false
    } else {
        while left <= right {
            let mid = (left + right) / 2
            let sum = mid * (number - mid)
            
            if k == sum {
                isPossible = true
                break
            } else if k < sum {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
    }
} else {
    // 홀수
    // left, right는 한 줄에 들어갈 수 있는 사각형의 개수
    // number는 기준 수
    
    let number = n + 2
    var right = number - 1
    var left = number / 2 + 1
    
    
    if k == left * (left - 1) || k == right {
        isPossible = true
    } else if k > left * (left - 1) || k < right {
        isPossible = false
    } else {
        while left <= right {
            let mid = (left + right) / 2
            let sum = mid * (number - mid)
            
            if k == sum {
                isPossible = true
                break
            } else if k < sum {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
    }
}

if isPossible {
    print("YES")
} else {
    print("NO")
}

