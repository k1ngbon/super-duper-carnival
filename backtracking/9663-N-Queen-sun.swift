/*
- https://www.acmicpc.net/problem/9663
- 백트래킹(dfs)

- 주어진 칸에 퀸을 놓을 수 있는지를 확인하기 위해서 기존 퀸의 위치를 배열에 담고 배열의 각 값과 비교할 수도 있지만 
   이 경우 배열의 크기와 걸리는 시간이 비례해서 증가함
- 따라서 이를 O(1)안에 확인할 수 있도록 개선할 수 있는데 열, 왼쪽 대각선, 오른쪽 대각선 이렇게 3가지 경우마다 
  visited 배열을 선언해주고 셋 다 아직 방문되지 않은 경우에만 퀸을 놓도록 하면 된다!
*/

import Foundation

print(solution(Int(String(readLine()!))!))

func solution(_ N: Int) -> Int {
    var down = Array(repeating: false, count: N)
    /// 합, 차는 최대값이 2 * N 이므로 배열을 더 크게 선언
    var diagonalLeft = Array(repeating: false, count: 2 * N)
    var diagonalRight = diagonalLeft

    func nQueen(row: Int = 0) -> Int {
        guard row != N
        else {
            return 1
        }

        var answer = 0
        for col in 0..<N {
            let sum = row + col
            /// 음수가 되는 걸 막아야 하는데 abs로 하면 서로 가운데를 제외하고 두 줄씩 값이 같아지므로 N을 더함
            let diff = N + row - col
            guard !down[col], !diagonalRight[diff], !diagonalLeft[sum]
            else {
                continue
            }

            down[col].toggle()
            diagonalRight[diff].toggle()
            diagonalLeft[sum].toggle()
            answer += nQueen(row: row + 1)
            down[col].toggle()
            diagonalRight[diff].toggle()
            diagonalLeft[sum].toggle()
        }

        return answer
    }

    return nQueen()
}
