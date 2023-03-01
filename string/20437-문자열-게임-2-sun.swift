/*
 - https://www.acmicpc.net/problem/20437
 - 문자열
 - 임의의 문자를 K개 포함하는 최소, 최대 길이를 구하는건데 조건에 의해 결국 최소든 최대든 항상 해당 문자로 끝나야 한다.
   그래서 문자열을 쭉 돌면서 해당 문자가 나올 떄마다 위치를 저장했다가 K개를 충족하는 순간 매번 길이를 계산해서 최소, 최대를 업데이트
    - 처음에는 아예 딕셔너리의 배열의 크기가 항상 K 이하가 되도록 removeFirst()를 해줬다가 이러면 N^2라 혹시 터질까봐
      그냥 인덱스 사용해서 계산하는 방식으로 변경했다...근데 removeFirst()도 안 터짐 ㅎ 
 */

import Foundation

func solution(string: String, K: Int) -> [Int] {
    var dict = [Character: [Int]](), minLength = 10001, maxLength = 0

    for (index, string) in string.enumerated() {
        dict[string, default: []].append(index)

        guard let indices = dict[string],
              indices.count >= K
        else {
            continue
        }

        let length = indices.last! - indices[indices.endIndex - K] + 1
        minLength = min(minLength, length)
        maxLength = max(maxLength, length)
    }

    return maxLength != 0 ? [minLength, maxLength] : [-1]
}


let N = Int(readLine()!)!

for _ in 0..<N {
    let string = readLine()!, K = Int(readLine()!)!
    print(solution(string: string, K: K).map { String($0) }.joined(separator: " "))
}
