/*
- https://school.programmers.co.kr/learn/courses/30/lessons/136797
- DP

생각 과정
- dp를 생각하기는 했는데 단순히 왼쪽, 오른쪽의 최소 비용만 저장하는 방식으로 접근했다가 수많은 예외에 결국 포기하고 답을 봤다... 
- 근데 봐도 이해하는 데 한참 걸렸음 너무 어려워요... 
- 애초에 접근을 잘못했던 게 (left, right) 조합 별로 최소 거리를 저장하는 식으로 접근했어야 했다...
  2차원 배열을 사용해서 graph[left][right]을 업데이트 해주는 방식으로...
- 또 하나의 포인트는 문제 조건에 따라 guard문에서 left != right로 손가락이 같은 숫자에 있는 경우를 막아주는 것!
  보면서 이게 되게 신박하다는 생각이 들었다. 
  걍 일단 계산할 떄는 겹치든 말든 고민 안하고 다음에 해당 값을 사용할 때 left == right이면 겹치는 거니까 건너뛰는 식!
*/
import Foundation

private let distances = [
    [1, 7, 6, 7, 5, 4, 5, 3, 2, 3],
    [7, 1, 2, 4, 2, 3, 5, 4, 5, 6],
    [6, 2, 1, 2, 3, 2, 3, 5, 4, 5],
    [7, 4, 2, 1, 5, 3, 2, 6, 5, 4],
    [5, 2, 3, 5, 1, 2, 4, 2, 3, 5],
    [4, 3, 2, 3, 2, 1, 2, 3, 2, 3],
    [5, 5, 3, 2, 4, 2, 1, 5, 3, 2],
    [3, 4, 5, 6, 2, 3, 5, 1, 2, 4],
    [2, 5, 4, 5, 3, 2, 3, 2, 1, 2],
    [3, 6, 5, 4, 5, 3, 2, 4, 2, 1]
]

func solution(_ numbers: String) -> Int {
    let N = 10, numbers = numbers.map { Int(String($0))! }
    let board = Array(repeating: Array(repeating: Int.max, count: N), count: N)
    // graph[left][right]: left, right의 조합으로 (둘 중에 한 손이) 현재 번호를 누르는 최소 비용
    var graph = board
    graph[4][6] = 0

    for number in numbers {
        let prev = graph
        graph = board

        for left in 0..<N {
            for right in 0..<N {
                let prevSum = prev[left][right]
                guard prevSum != .max, // 불가능한 경우
                      left != right // 손가락이 겹치는 경우
                else {
                    continue
                }

                // 왼손으로 누르는 경우
                graph[number][right] = min(graph[number][right], prevSum + distances[left][number])
                // 오른손으로 누르는 경우
                graph[left][number] = min(graph[left][number], prevSum + distances[right][number])
            }
        }
    }

    return graph.map { $0.min()! }.min()!
}
