/*
 - https://www.acmicpc.net/problem/3107
 - 문자열
 - 간단한데 예외 처리를 잘 해야되는 문제였다...
   "::"이 시작이냐 끝이냐 중간에 있냐에 따라 skippedZeros 형태를 어떻게 해야될까 하다가 걍 시간도 넉넉한데 무한 split으로 가보자고~
   즉, 어떤 케이스든 생략된 0을 다 집어 넣은 상태에서 각 자리의 16진수 사이에 콜론이 1개 이상 있도록 보장하면
   이걸 다시 콜론으로 split 했을 때 1개든 N개든, 맨 앞/뒤에 불필요하게 추가로 붙어있든 어차피 다 사라지므로
   각 자리의 16진수는 제대로 얻을 수 있다는 점에 착안해서 풀었다...내 자신 칭찬해~~~~
 */

import Foundation

func solution(string: String) -> String {
    let colon: Character = ":"
    let skippedZeroCount = 8 - string.split(separator: colon).count
    let skippedZeros = String(repeating: ":0:", count: skippedZeroCount)

    return string
        .replacingOccurrences(of: "::", with: skippedZeros)
        .split(separator: colon)
        .map { String($0).zeroPadded() }
        .joined(separator: String(colon))
}

extension String {
    func zeroPadded() -> String {
        String(repeating: "0", count: max(4 - count, 0)) + self
    }
}

print(solution(string: readLine()!))
