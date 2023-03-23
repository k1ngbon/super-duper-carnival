/*
- https://school.programmers.co.kr/learn/courses/30/lessons/152995?language=swift
- 정렬
- 처음 풀이는 아주 지랄이었음 ㅋㅎ 임의의 사원이 인센티브를 받으려면 자기보다 점수의 총합이 큰 사원들 중에 둘 다 점수가 높은 사람이 있으면 안되니까
  이걸 뭔가 범위를 계산할 수 있지 않을까 하고 고민했는데 계속 하나씩 안되고 시간초과 나는 풀이밖에 생각 안났다...
- 계속 점수 총합 순으로 접근하는 거에 꽂혀서 헤맸는데 그나마 제일 시간 줄이는 게 근무 태도 점수를 배열로 따로 관리하고
  새로운 사원을 확인할 떄마다 배열에서 근무 태도 점수와 같거나 가장 가까운 큰 값을 찾아서 해당 점수에 대응되는 동료 평가 점수를 확인해서 그거보다 크면 ㅇㅋ
- 다른 사람 풀이를 보니까 총합이 아니고 그냥 근무 태도를 기준으로 정렬을 하고, 동일한 점수 내에서는 동료 평가 점수가 작은 순으로 정렬하면 
  그냥 계속 기준 값을 갱신하면서 해당 값을 넘는지만 확인하면 된다... 
- 근데 이 문제는 진짜 어케 접근하는 게 맞는 지 너무 감이 안왔다...이건 정렬 기준을 다양하게 따져봤으면 풀렸을 문제!
*/

import Foundation

func solution(_ scores:[[Int]]) -> Int {
    let wanho = scores[0], wanhoScore = wanho.reduce(0, +)
    /// 완호가 인센티브를 받을 수 있는 지를 간단하게 게산하기 위해 완호보다 점수가 큰 애들만 남겨서 필터링
    let filteredScores = scores.filter { $0[0] + $0[1] > wanhoScore } + [wanho]
    /// cap 갱신이 간단해지도록 근무 태도 내림차순 + 근무 태도가 같으면 동료 평가 오름차순
    let sortedScores = filteredScores.sorted { $0[0] != $1[0] ? $0[0] > $1[0] : $0[1] < $1[1] }
    var cap = (work: Int.max, peer: 0), count = 0, hasIncentive = false

    for score in sortedScores {
        let work = score[0], peer = score[1]
        /// 근무 태도가 같으면 동료 평가 오름차순으로 정렬되어 있고,
        /// 근무 태도가 다르면 근무 태도는 내림차순이므로 항상 cap.work가 더 크기 때문에 
        /// peer >= cap.peer 일 때만 인센티브를 받을 수 있음!
        /// 따라서 인센티브를 받을 수 있을 때마다 cap을 업데이트하고 매 기마다 위 조건을 만족하는 지 확인하면 끝
        guard peer >= cap.peer
        else {
            continue
        }

        if wanho[0] == work, wanho[1] == peer {
            hasIncentive = true
        }
        count += 1
        cap = (work, peer)
    }

    return hasIncentive ? count : -1
}
