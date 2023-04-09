/*
- https://www.acmicpc.net/problem/27212
- DP

생각 과정
- 예전에 쇼미더코드 때 못 풀어서 다시 풀어봄
- 딱 보고 DP구나라고는 생각했는데 되게 복잡한 DP 방식만 생각해서 틀렸습니다 파티~~~
- 그러다가 그래프는 그냥 임의의 A대 학생 a가 B대학의 bIndex번째 학생까지 선택할 수 있을 때 각 경우의 최적을 저장하고,
  이전 기의 정보를 사용해서 a가 새로 선택할 수 있는 bIndex의 학생을 선택할 수 있을 때 최적 값을 업데이트하면 됨을 꺠달음
- 이때 최적 값을 구하려면 따져야되는 경우의 수가 3가지인데 이걸 다 고려해야 된다! 
    1. a는 아예 선택하지 않는 게 최적인 경우 
    2. a가 직전 최적 선택을 유지하는 게 최적인 경우
    3. a가 새로 추가된 B대학의 학생을 선택하는 경우 

기타
- DP 풀 때는 뭔가 복잡하다 싶으면 좀 더 쉬운 방법이 없는 지 고민해보기 특히 dp 배열의 형태가 잘못되었을 확률이 큼~~~
*/

import Foundation

private func solution(_ A: [Int], _ B: [Int], _ happy: [[Int]] ) -> Int {
    let B = [0] + B, board = Array(repeating: 0, count: B.count + 1)
    var graph = board

    for a in A {
        var now = [0]
        for bIndex in 1..<B.count {
            let b = B[bIndex], exclude = graph[bIndex]
            let include = max(happy[a][b] + graph[bIndex - 1], now.last!)
            now.append(max(exclude, include))
        }

        graph = now
    }

    return graph.max()!
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var happy = [[Int]]()

for _ in 0..<input[2] {
    happy.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

let A = readLine()!.split(separator: " ").map { Int(String($0))! - 1 }
let B = readLine()!.split(separator: " ").map { Int(String($0))! - 1 }

print(solution(A, B, happy))
