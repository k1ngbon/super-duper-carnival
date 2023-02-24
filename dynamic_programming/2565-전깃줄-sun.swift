/*
 - https://www.acmicpc.net/problem/2565
 - LIS(DP)
 - 처음에는 어떤 전깃줄을 포함하느냐 아니냐의 문제라고 생각해서 냅색인가 했음
   근데 단순한 냅색이 아니라 전깃줄 처리 순서에 따라서 초기화가 필요한 경우도 있고,
   전깃줄을 단순 정렬로는 해결이 안 되길래 그럼 혹시 그리디...? 하다가 조짐..ㅎ
 - 암튼 그리디 될 것 같았는데(교차 개수가 많은 전깃줄부터 제거)
   교차점 수가 동일한 게 여러 개인 경우 이 중에 뭘 선택하는 지에 따라 정답 여부가 갈려서 이건 애초에 그른 방식이었다...
 - 결국 답 보고 LIS 써야되는 거구나 했는데 여기서 두번쨰 삽질..ㅎ
    - 스택에 유효한 전깃줄만 계속 쌓는 방식으로 연산했는데 첨에는 맨 위 전깃줄이랑 교차하는 경우에만 top을 교체하고
      2개 이상 교차하는 경우 스택에 추가를 안했음
    - 근데 스택에는 걍 새로 확인하는 전깃줄의 b가 스택에 있는 전깃줄보다 b가 작기만 하면 그 중에 젤 아래에 있는 거랑 바꾸면 되는 거였음
      엥 그러면 스택에 LIS가 아니라 뭔가 교차된 형태의 전깃줄들이 되어 버리는 거 아님? 싶었는데
      핵심은 새로운 전깃줄이 여러 개랑 교차되더라도 그 중에 젤 위가 아니라 젤 밑에 있는 거랑 바꿔주면 ㅇㅋ임
      왜냐면 어차피 지금 스택 길이 만큼은 교차되지 않는 구성을 한 번이라도 만족한 거고,
      이 중에서 top만 살아남으면 어쨌든 지금 크기의 스택을 최초로 만족했을 때의 b값 상한선은 계속 유지하게 되는거니까 괜찮다...
      스택 안의 값이 어떻든 결국 상한선이 기준점이기 때문에...대충 예시 넣어서 해 보면 앎...ㅎ
    - 이거 말고 주의할 점은 a 기준으로 전깃줄 정렬하고 LIS 비교해야되는 거...? 반례 거의 바로 찾기 가능~~~

 // MARK: - 결론
 - 사실 냅색인가 생각한 거 자체는 괜찮았던 것 같다 LIS를 바로 눈치채면 좋겠지만 그건 어려울 거 같아서 먼가
   >>> 냅색같은데 -> 근데 그냥 냅색은 아니네 -> 어 답 순서가 증가하는 수열이다 -> LIS구나 <<<
   과정으로 추론했으면 좋았을 거 같은...?
 -
*/

import Foundation

typealias Wire = (a: Int, b: Int)

func solution(N: Int, wires: [Wire]) -> Int {
    let wires = wires.sorted { $0.a < $1.a }
    var dp = Array(repeating: 1, count: N), stack = [wires[0].b]

    for index in 1..<N {
        let wire = wires[index]

        if let stackIndex = stack.firstIndex(where: { wire.b < $0 }) { // update
            dp[index] = dp[index - 1]
            stack[stackIndex] = wire.b
        } else { // append
            dp[index] = dp[index - 1] + 1
            stack.append(wire.b)
        }
    }

    return N - dp.last!
}

let N = Int(readLine()!)!
var wires = [Wire]()

for _ in 0..<N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    wires.append(Wire(a: input[0], b: input[1]))
}

print(solution(N: N, wires: wires))

