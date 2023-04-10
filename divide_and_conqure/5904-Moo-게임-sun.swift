/*
- https://www.acmicpc.net/problem/5904
- 분할정복

생각과정
- 처음에는 단순히 bottom-up을 생각했는데 당연히 시간초과... 
- 길이만 계산하는 건 10^9가 28번 만인가? 암튼 금방이라 뭔가 m, o가 나오는 규칙을 찾을 수 있지 않을까 싶어서 고민함
- 길이를 일단 구한 다음에 위에서 아래로 분할정복으로 내려오면서 가운데면 바로 리턴하고 앞뒤면 계속 탐색하는 방식으로 해결~

기타
- 처음에 뒤면 땅겨주는 걸 숫자를 잘못 넣어서 삽질~
*/

import Foundation

private func solution(_ N: Int) -> String {
    let m = "m", o = "o", base = [m, o, o], lengths = calculateLengths(N: N)

    func dq(index: Int, target: Int) -> String {
        if index == 0 {
            return base[target]
        }

        let mid = (start: lengths[index - 1], end: lengths[index - 1] + index + 2)
        if mid.start...mid.end ~= target {
            return mid.start == target ? m : o
        }

        let target = target - (target < mid.start ? 0 : mid.end + 1)
        return dq(index: index - 1, target: target)
    }

    return dq(index: lengths.count - 1, target: N - 1)
}

private func calculateLengths(N: Int) -> [Int] {
    var length = 3, index = 1, lengths = [length]

    while length < N {
        length += length + index + 3
        lengths.append(length)
        index += 1
    }

    return lengths
}

print(solution(Int(readLine()!)!))
