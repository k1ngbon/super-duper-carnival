/*
- https://school.programmers.co.kr/learn/courses/30/lessons/12904
- 투포인터

생각 과정
- 사실 나는 걍 적절한 풀이가 생각이 안나서 그냥 큰 길이부터 완탐으로 다 돌렸다 ㅎ 통과안 될 줄 알았는데 됨 
- 근데 최적 풀이 보니까 각각 2칸, 3칸으로 구성된 2개의 투포인터를 사용해서 팰린드롬을 발견하는 경우 더 탐색하는 방식

기타
- 백준 죽어도 통과 안 됨ㅎ

*/

import Foundation

func solution(_ s:String) -> Int {
    guard s != String(s.reversed())
    else {
        return s.count
    }
    
    let string = s.map { String($0) }, count = string.count
    
    func expand(left: Int, right: Int) -> Int {
        var left = left, right = right
        
        while left >= 0, right < count, string[left] == string[right] {
            left -= 1
            right += 1
        }
        
        return right - left - 1
    }
    
    var maxLength = 1
    
    for start in 0..<count - 1 {
        maxLength = max(
            maxLength, 
            expand(left: start, right: start + 1),
            expand(left: start, right: start + 2)
        )
    }
    
    return maxLength
}
