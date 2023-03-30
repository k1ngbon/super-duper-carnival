/*
- https://school.programmers.co.kr/learn/courses/30/lessons/12987
- 정렬
- A팀 전체의 순서는 사실 상관없고 걍 어떤 참가자가 나오면 거기에 대응해서 내보내기만 하면 되므로 정렬하면 ez...이게 왜 3단계...?
*/

import Foundation

func solution(_ a:[Int], _ b:[Int]) -> Int {
    let a = a.sorted(), b = b.sorted()
    var wins = 0, aIndex = 0, bIndex = 0
    
    while aIndex < a.endIndex, bIndex < b.endIndex {
        let hasBteamWon = b[bIndex] > a[aIndex]
        bIndex += 1
        aIndex += hasBteamWon ? 1 : 0
        wins += hasBteamWon ? 1 : 0
    }
    
    return wins
}
