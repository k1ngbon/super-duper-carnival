/*
 - https://www.acmicpc.net/problem/20444
 - 이분탐색
 - n이 말도 안되게 크니까 이분탐색~
 - 예제를 손으로 풀어보면서 가로로 자르면 열 개수만큼 추가로 늘어나고 세로로 자르면 행 개수만큼 추가로 늘어나는 걸 발견했다.
 - 그래서 뭔가 가로로 자르는 횟수(i)를 이분탐색으로 좁혀나가면 세로 횟수는 N - i 가 되니까
   이 경우 자르는 횟수가 K를 만족하는지 확인하는 식으로 이분탐색을 할 수 있겠다 싶었음
 - 그럼 이제 잘린 개수는 어케 구할 수 있을까 했는데 자르는 순서는 상관이 없으니까 가로 횟수만큼 다 자르고 세로 횟수로 자른다고 생각하면
   (i + 1) * (N - i + 1)라는 식을 도출!
 - 끝~
 */

import Foundation

enum MyAnswer: String {
    case YES, NO
}

func solution(N: Int, K: Int) -> MyAnswer {
    func calculateNumberOfCutPieces(row: Int) -> Int {
        (row + 1) * (N - row + 1)
    }

    var lo = 0, hi = N

    while lo <= hi {
        let mid = (lo + hi) / 2, pieces = calculateNumberOfCutPieces(row: mid)
        if pieces == K {
            return .YES
        } else if pieces < K {
            lo = mid + 1
        } else {
            hi = mid - 1
        }
    }

    return .NO
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
print(solution(N: input[0], K: input[1]).rawValue)
