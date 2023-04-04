/*
- https://school.programmers.co.kr/learn/courses/30/lessons/12971#
- DP 

생각 과정
- 사실은...비슷한 문제를 이미 풀어봄 ㅎ
- 일단 특정 스티커를 뜯을 거냐 아니냐의 문제이므로 냅색 문제로 접근할 수 있다는 걸 알 수 있었다
- 이제 포함 기준을 어케할 건지가 문젠데 마지막 스티커를 뜯을 수 있는 지 여부는 결국 첫 번쨰 스티커를 뜯었는 가에 따라 달렸음
  만약 원형이 아니었다면 경우의 수를 나눌 필요가 없지만 원형이기 떄문에 
  아예 첫 번쨰 스티커를 뜯은 경우와 안 뜯은 경우를 나눠서 각각 dp를 돌려서 최대값을 구하고 둘 중 더 큰 게 정답
*/

import Foundation

func solution(_ sticker:[Int]) -> Int{
    max(
        dp(Array(sticker.dropLast().dropFirst(2))) + sticker[0],
        dp(sticker.suffix(sticker.count - 1))
    )
}

private func dp(_ stickers: [Int]) -> Int {
    let x = 0, o = 1
    var dp = [0, 0]
    
    for sticker in stickers {
        (dp[x], dp[o]) = (dp.max()!, dp[x] + sticker)
    }
    
    return dp.max()!
}
