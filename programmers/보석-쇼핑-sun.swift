/*
- https://school.programmers.co.kr/learn/courses/30/lessons/67258
- 이분탐색 + 슬라이딩 윈도우 
- 이분탐색을 통해서 길이를 좁혀나가야겠다는 생각은 금방 했는데 이분탐색으로 설정한 범위를 만족하는 값을 어떻게 구하느냐가 문제였다
  슬라이딩 윈도우를 생각하긴 했는데 결국 for문 두 번 도는 것곽 같지 않나라는 생각이 들어서 처음에 2중 for문으로 했다가 시간초과~
  결국 질문 게시판 보고 슬라이딩 윈도우로 구현했는데 딕셔너리의 count 프로퍼티가 O(N)일 줄 알았는 데 O(1)이었다... 
*/
import Foundation

func solution(_ gems:[String]) -> [Int] {
    let totalGems = Set(gems).count
    var lo = totalGems, hi = gems.count, answer = [Int]()


    while lo <= hi {
        let mid = (lo + hi) / 2
        let range = findPossibleRange(ofLength: mid, gems: gems, totalGems: totalGems)
        if range.isEmpty {
            lo = mid + 1
        } else {
            answer = range
            hi = mid - 1
        }
    }

    return answer
}

private func findPossibleRange(ofLength length: Int, gems: [String], totalGems: Int) -> [Int] {
    var dict = [String: Int](), start = 0, end = start + length - 1, range = [Int]()
    for index in stride(from: 0, to: end, by: 1) {
        dict[gems[index], default: 0] += 1
    }

    while end < gems.count {
        dict[gems[end], default: 0] += 1
        if dict.count == totalGems {
            return [start + 1, end + 1]
        }

        let startGem = gems[start]
        dict[startGem] = dict[startGem] == 1 ? nil : dict[startGem]! - 1 
        start += 1
        end += 1
    }

    return []
}
