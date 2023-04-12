/*
- https://www.acmicpc.net/problem/1548
- 완전탐색

생각 과정
- 일단 정렬해서 작은 수 2개의 합이 큰 수보다 크면 삼각 수열으로 판별하면 되겠다고 생각했다
- 처음에는 단순히 삼각 수열이 아닌 애들을 빼서 가장 큰 수만 제거하는 식으로 생각했는데 바로 아웃
  크거나 작은 애를 빼는 건 안되는구나 꺠달았다...
- 어떤 숫자를 빼야될까 써서 보다가 삼각 수열이 아닌 조합 중 가장 큰 숫자 혹은 가장 작은 숫자를 빼면 된다는 것을 깨달았다.. 
  그래서 길이를 기준으로 또 완전탐색해서 가보면 어떨까 생각했음! 간당간당하게 통과할 것 같았다
- 그리고 처음에는 dfs로 돌았는데 3자리만 순회하니까 그냥 3중 포문으로 바꿔줬다...  
- 마지막으로 다른 사람들 풀이 보니까 그냥 매 인덱스마다 최장 길이를 찾아주는 2중 포문으로도 가능해서 최종 변경~

기타
- 길이가 2 미만인 경우도 고려해줘야 하는 함정이 있었다 ㅎ
*/

import Foundation

func solution(_ numbers: [Int]) -> Int {
    let numbers = numbers.sorted()
    var maxLength = 0

    for start in stride(from: 0, to: numbers.count, by: 1) {
        let mid = start + 1
        var end = start + 2

        while end < numbers.count, numbers[start] + numbers[mid] > numbers[end] {
            end += 1
        }

        maxLength = max(maxLength, end - start)
    }

    return numbers.count < 3 ? numbers.count : maxLength
}

let _ = readLine()
print(solution(readLine()!.split(separator: " ").map { Int(String($0))! }))
