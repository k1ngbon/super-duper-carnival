/*
- https://www.acmicpc.net/problem/2932
- 구현

생각 과정
- 처음에는 그냥 N * N 그래프 만들어서 찐으로 회전시켰다
  나름대로 시간 초과날까봐 위치도 별도의 배열로 선언해줬는데 응~ 메모리 초과~
  N * N 이 최악의 경우 1억이니까..당연히... 
- 그래서 다른 거 하다가 다시 왔더니 문득 그냥 moves에 들어있는 숫자들만 위치를 기억하고, 
  매 move마다 moves를 전체 탐색해서 동일 열/행인 애들만 옮겨주면 되지 않을까 싶었다 
  그러면 최악의 경우 1000 * (1000 + 1000) 이니까 넉넉~
- 실버라기엔...어려웠다...쉬운 골5보다 어려운 늑김~
*/

import Foundation

func solution(_ N: Int, _ moves: [[Int]]) -> [Int] {
    var answer = [Int](), dict = [Int: (row: Int, col: Int)]()
    let moves = moves.map {
        let num = $0[0]
        dict[num] = ((num - 1) / N, (num - 1) % N)
        return [num, $0[1] - 1, $0[2] - 1]
    }

    for move in moves {
        let number = move[0], new = (row: move[1], col: move[2])
        let (row, col) = dict[number]!

        // move col
        let colMove = (new.col + N - col) % N
        for num in dict.keys {
            let (nr, nc) = dict[num]!
            dict[num]?.col = nr == row ? (nc + colMove) % N : nc
        }

        // move move
        let rowMove = (new.row + N - row) % N
        for num in dict.keys {
            let (nr, nc) = dict[num]!
            dict[num]?.row = nc == new.col ? (nr + rowMove) % N : nr
        }

        answer.append(colMove + rowMove)
    }

    return answer
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var move = [[Int]]()

for _ in 0..<input[1] {
   move.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(input[0], move).map { String($0) }.joined(separator: "\n"))
