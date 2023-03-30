/*
- https://school.programmers.co.kr/learn/courses/30/lessons/12979
- 구현
- N이 2억이라 단순 순회는 안 될 줄 알았는데 된다고 함..?
- 암튼 예제 따라서 해보다가 결국 새로 설치해야 하는 기지국의 개수는 
  기지국이 없는 각 구간을 하나의 기지국이 커버할 수 있는 범위로 나눈 값을 올림해서 합하면 된다는 것을 깨달음!
  근데 이렇게 풀면 구간을 구할 때 맨 마지막에 기지국이 없으면 누락돼서 처음에는 [n + 1]을 해줬는데 틀렸습니다 파티~
- 구간을 구할 때 해당 위치에서 커버할 수 있는 범위인 w만큼 빼주고 있어서 n + 1 을 기지국 배열에 더하면 계산 시에는 n + 1 - w 을 기준으로 계산하게 되니까
  기지국 배열에 n + 1 + w 로 추가해줬어야 됐는데 실수했다ㅠ 
  
*/

import Foundation

func solution(_ n:Int, _ stations:[Int], _ w:Int) -> Int{
    let coverage = 1 + 2 * w, stations = stations + [n + 1 + w]
    var start = 1, answer = 0, chunks = [Int]()

    for station in stations {
        let chunk = station - w - start
        answer += chunk > 0 ? Int(ceil(Double(chunk) / Double(coverage))): 0
        start = station + w + 1
    }

    return answer
}
