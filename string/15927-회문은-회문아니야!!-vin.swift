// MARK: - 15927: 회문은 회문아니야!!

let string = readLine()!.map { String($0) }
var left = 0, right = string.count - 1
var maxLength = -1
var allSatisfyOneCharacter: Bool = true

while left <= right {
    let leftChar = string[left]
    let rightChar = string[right]
    
    if leftChar != rightChar {
        // 회문아님!
        maxLength = string.count
        break
    } else {
        // 회문일수도 있음
        left += 1
        right -= 1
        if (left < string.count && string[left] != rightChar) || (right >= 0 && string[right] != leftChar) {
            // 근데 아니네?
            allSatisfyOneCharacter = false
        }
    }
}

print(maxLength > 0 ? maxLength : allSatisfyOneCharacter ? -1 : string.count - 1)
