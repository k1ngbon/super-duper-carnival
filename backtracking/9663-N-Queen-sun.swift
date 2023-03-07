/*
 - https://www.acmicpc.net/problem/9663
 - 백트래킹(dfs)
 - 모르겠어요...모르겠어요....
 - 여러 솔루션을 보고 1차원 배열 + 대각선은 shift 개념을 사용해야 된다는 건 알았는데 아래 블로그 풀이가 시간 복잡도가 훨씬 개선되는데
   아무리 봐도 이해를 못하겠다..gg^^
    - 미래의 나야...화이팅...https://hyun083.tistory.com/63
 */

import Foundation

func solution(N: Int) -> Int {
    let above = Array(repeating: true, count: N)
    let leftDiagonal = Array(repeating: true, count: N)
    let rightDiagonal = Array(repeating: true, count: N)

    func dfs(row: Int, above: [Bool], leftDiagonal: [Bool], rightDiagonal: [Bool]) -> Int {
        guard row != N
        else {
            return 1
        }

        var answer = 0
        for col in 0..<N {
            guard above[col], leftDiagonal[col], rightDiagonal[col]
            else {
                continue
            }

            var above = above, leftDiagonal = leftDiagonal, rightDiagonal = rightDiagonal
            leftDiagonal.removeLast()
            leftDiagonal.insert(true, at: 0)
            rightDiagonal.removeFirst()
            rightDiagonal.append(true)
            above[col] = false
            if col + 1 < N {
                leftDiagonal[col + 1] = false
            }
            if col - 1 >= 0 {
                rightDiagonal[col - 1] = false
            }
            answer += dfs(row: row + 1, above: above, leftDiagonal: leftDiagonal, rightDiagonal: rightDiagonal)
        }

        return answer
    }

    return dfs(row: 0, above: above, leftDiagonal: leftDiagonal, rightDiagonal: rightDiagonal)
}

print(solution(N: Int(readLine()!)!))
