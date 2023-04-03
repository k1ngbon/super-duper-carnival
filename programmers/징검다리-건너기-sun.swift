/*
- https://school.programmers.co.kr/learn/courses/30/lessons/64062
- 이분탐색

생각 과정
- 음 일단 효율성 버리고 푼다고 생각하면 친구가 무제한이니까 친구 수 기준으로는 못 따지겠고.. 
  걍 반복문 돌면서 매 기마다 1씩 줄여가면서 k개 이상 0 이하인 구간이 나오면 종료
- 그럼 뭔가 가장 숫자가 작은 디딤돌이 소진되는 거랑 상관있을 거 같은데...
  얘 기준으로 k칸 이내의 모든 디딤돌이 소진되는 시점까지만 건널 수 있음!
- 숫자가 작은 디딤돌이 여러 개일 수도 있으니까 다 따지는 건 복잡하고 시간복잡도도 높을 것 같은데 간단하게 못 구하나...
- 이분탐색으로 건널 수 있는 친구 수 n을 좁혀 나가고 stones 배열에서 n만큼 빼서 가능한지 검증하면
  시간복잡도가 대충 stones.count * log(stones.max()!) 니까 최악의 경우에도 세잎~~~~
- 디딤돌 숫자가 모두 같은 경우랑 k가 충분히 커서 최대 디딤돌 숫자가 최대 친구 개수인 테케 확인 필요
  -> 0 이하가 아니라 미만으로 해야되는데 잘못함~~~~~

기타
- 진짜 이상한 거 isPossibleNumber(_:stones:maxSkip:) 메서드에서 원래 for문을 인덱스 말고 
  for stone in stones 로 배열 자체를 바로 순회했는데 이러니까 효율성 테스트에서 시간초과가 떴다...
  아무리 생각해도 시간 초과 날 이유가 없는 거 같은데 접근 자체가 잘못됐나 싶어서 질문들을 보다가 
  인덱싱이 훨씬 빠르다는 답변을 보고 고쳤는데 바로 통과...비교해보니 최대 5배 정도 차이나는데 음...실화...?
*/
import Foundation

func solution(_ stones:[Int], _ k:Int) -> Int {
    var lo = 1, hi = stones.max()!
    
    while lo <= hi {
        let mid = (lo + hi) / 2
        if isPossibleNumber(mid, stones: stones, maxSkip: k) {
            lo = mid + 1
        } else {
            hi = mid - 1
        }
    }
    
    return hi
}

private func isPossibleNumber(_ number: Int, stones: [Int], maxSkip: Int) -> Bool {
    var skipCount = 0
    
    for index in 0..<stones.endIndex {
        let stone = stones[index] - number
        skipCount = stone < 0 ? skipCount + 1 : 0
        if skipCount == maxSkip {
            return false
        }
    }

    return true
}