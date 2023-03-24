/*
- https://school.programmers.co.kr/learn/courses/30/lessons/150367?language=swift
- 분할정복(재귀)
- 문제 이해가 오래 걸려서 그렇지 문제 자체는 이해하고 나면 무난했던 것 같다 근데 하나 놓쳐서 그냥 시간 호록~
- 어떤 숫자가 주어지면 그 숫자를 이진수로 변환해서 1. 완전 트리를 만들고 2. 분할정복으로 유효한지 확인하면 끝
- 완전 트리를 만들기 위해서는 해당 숫자가 완전 트리가 되기 위해 필요한 만큼 0을 패딩해주면 된다 
  이건 걍 구현 + 수학에 가까웠음 그냥 몇 층인지 계산해서 해당 층을 완전트리로 만들기 위한 노드 개수를 충족하도록 0 붙여주면 됨
- 분할정복으로 트리 확인 이거는 그냥 계속 가운데를 기준으로 분할정복하면서 유효한 트리인지 확인하면 되는데 
  주의할 점이 2개 있다...하나는 부모 노드 중 하나라도 더미 노드가 있었으면 해당 서브 트리가 유효하기 위해서는 자식 노드도 모두 더미여야 함
  이거는 빨리 파악해서 인자로 계속 부모 노드 중 하나라도 더미이면 hasDummyRoot 인자를 통해 이를 전달하도록
- 근데 아무리봐도 다 한 거 같은데 진짜 죽어도 계속 75점~~~ 미칠 거 같았다...다른 사람들 풀이 봐도 아이디어 똑!같!아!
  결국 다른 사람 풀이 그대로 해보다가 내가 부모는 더미인데 현재 루트는 더미가 아닌 경우를 놓치고 있음을 깨달음~
  그래서 isDummy 변수를 추가하고 이걸로 추가 고려해줬더니 통과~
    - 참고했던 풀이는 아예 부모가 더미이면 바로 자식 중에 더미가 아닌 노드가 있는 지 확인해서 하나라도 더미가 아니면 바로 false 리턴하는 방식이었는데 
      그래서 나같이 멍청하게 실수할 여지가 훨씬 적었다... 
- 탈출조건을 확실히 고려하고 써두자. 아무리 봐도 로직이 맞으면 짜잘한 조건을 놓친 거니까 차라리 날리고 함수를 다시 쓰면 뭘 놓쳤는 지 보일듯...
*/

import Foundation

private let dummy: Character = "0"

func solution(_ numbers:[Int64]) -> [Int] {
    numbers.map {
        let tree = makePerfectBinaryTree(from: $0)
        return isValidTree(tree, hasDummyRoot: false) ? 1 : 0
    }
}

private func makePerfectBinaryTree(from number: Int64) -> [Character] {
    let bin = String(number, radix: 2).map { $0 }
    let level = Int(log2(Double(bin.count))) + 1
    let perfectLength = Int(pow(2, Double(level))) - 1
    let dummies = Array(repeating: dummy, count: perfectLength - bin.count)

    return dummies + bin
}

private func isValidTree(_ tree: [Character], hasDummyRoot: Bool) -> Bool {
    guard tree.count != 1
    else {
        return hasDummyRoot ? tree[0] == dummy : true
    }

    let mid = tree.count / 2, isDummy = tree[mid] == dummy
    guard !hasDummyRoot || isDummy
    else {
        return false
    }

    let hasDummyRoot = hasDummyRoot || isDummy
    let isLeftValid = isValidTree(Array(tree.prefix(mid)), hasDummyRoot: hasDummyRoot)
    let isRightValid = isValidTree(tree.suffix(mid), hasDummyRoot: hasDummyRoot)

    return isLeftValid && isRightValid
}

print(solution([7, 5, 0]))
