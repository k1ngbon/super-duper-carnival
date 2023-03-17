/*
 - https://www.acmicpc.net/problem/3079
 - 이분탐색
 - 예전에 못 푼 문제...만약에 값이 작았으면 그리디로도 할 수 있는 문젠데 인원이 무지막지하게 크다 ㅎ
 - 예제를 직접 쓰면서 풀다가 보면 결국 답이 결국 가장 오래 걸리는 줄의 시간을 최소화하는 문제라는 걸 깨달을 수 있다
   -> 이걸 못 깨달으면 조지는 것...ㅎ 뭔가 답의 특징? 답의 패턴을 찾으려고 의도적으로 노력하면 될 것 같기도?
   따라서 이분탐색을 통해서 시간 범위를 좁혀나가면서 만족할 수 있는 지 확인하면 됨
   만족 여부는 목표 시간 내에 각 부스가 상담할 수 있는 인원의 총합이 주어진 대기 인원보다 크거나 같은 지 확인하는 식
 */

import Foundation

func solution(peopleCount: Int, booths: [Int]) -> Int {
    func isPossibleTime(_ limit: Int) -> Bool {
        var count = 0

        for booth in booths {
            count += limit / booth
            if count >= peopleCount {
                return true
            }
        }

        return false
    }

    var lo = 1, hi = Int(booths.min()! * peopleCount)

    while lo <= hi {
        let mid = (lo + hi) / 2
        if isPossibleTime(mid) {
            hi = mid - 1
        } else {
            lo = mid + 1
        }
    }

    return lo
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var booths = [Int]()

for _ in 0..<input[0] {
    booths.append(Int(readLine()!)!)
}

print(solution(peopleCount: input[1], booths: booths))
