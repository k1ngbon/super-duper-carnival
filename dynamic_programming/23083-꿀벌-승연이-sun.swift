/*
- https://www.acmicpc.net/problem/23083
- 백준은 DP라는데 그냥 구현 느낌

생각과정
- 처음에는 잘못 생각해서 그냥 스택으로 풀었는데 이러면 모든 경로를 고려할 수 없었다.. 
- 그래서 재귀 dfs로 바꿨는데 당연히 시간초과 ㅋㅋ 문제에서 답을 10^9 % 7 하라고 한 거에서 눈치했어야 했는데..ㅎ
- 그래서 다시 봤더니 어차피 갈 수 있는 방향이 정해져 있어서 그냥 열 -> 행 순서대로 각 칸마다 확인하면서 
  해당 칸에서 갈 수 있는 다음 칸을 다 업데이트해주는 방식으로 접근!
- 근데 ㅎ 라스트팡으로 계산 과정에서도 10^9 % 7 로 나눠줬어야 했는데 안해서 런타임 에러~~~~~

기타 
- 꼼꼼히 읽자... 
- 육각형은 초기화가 답 없을 줄 알고 완전 미친놈이라고 생각했는데 그냥 2차원 배열로 하고 이동 방향 배열(dir)을 고민하면 되는 거였다...
*/
import Foundation

private let empty = Int.min, divider = Int(pow(10, 9.0)) + 7

func solution(_ N: Int, _ M: Int, _ empties: [[Int]]) -> Int {
    var graph = makeGraph(N, M, empties)
    graph[1][1] = 1
    // (짝, 홀)
    let dirs = [[(0, 1), (1, 0), (1, 1)], [(1, 0), (-1, 1), (0, 1)]]

    for col in 1...M {
        let dir = dirs[col % 2]

        for row in 1...N {
            guard graph[row][col] != empty
            else {
                continue
            }

            for (dr, dc) in dir {
                let nr = row + dr, nc = col + dc
                if graph[nr][nc] != empty {
                    graph[nr][nc] += graph[row][col] % divider
                }
            }
        }
    }

    return graph[N][M] % divider
}

private func makeGraph(_ N: Int, _ M: Int, _ empties: [[Int]]) -> [[Int]] {
    let room = 0
    let top = [Array(repeating: empty, count: M + 2)]
    let mid = [empty] + Array(repeating: room, count: M) + [empty]
    var graph = top + (0..<N).map { _ in mid } + top
    for pos in empties {
        graph[pos[0]][pos[1]] = empty
    }

    return graph
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var empties = [[Int]]()

for _ in 0..<Int(readLine()!)! {
    empties.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(input[0], input[1], empties))
