/*
 - https://www.acmicpc.net/problem/6443
 - 백트래킹(dfs)
 - 시간초과 미친놈~~~~~
    - 처음에는 혹시나 싶어서 일단 그냥 완탐 + set 을 사용한 풀이를 내봤는데 시간초과가 나왔다
    - 그래서 그 다음에는 visited set를 두고 중복이면 탐색을 멈추도록 하는 코드를 추가했는데 그래도 시간초과가 나왔다..
    - 아예 dfs 메서드 인자를 딕셔너리로 바꿔봤는데 그래도 시간초과^^
    - 중간 단계의 substring을 anagram이라는 set에 저장하고 있었는데 생각해 보니 visited 로직을 추가하면서 이건 불필요해져서
      혹시나 해서 이걸 배열로 바꿨더니 배열 인자, 딕셔너리 인자 모두 맞았다...띠용..?
    - set이 element에 대한 hash를 만드는 과정이 생각보다 오래걸려서 O(1)이라고는 하지만 append보다 유의미하게 더 소요되나...?

 // MARK: - 교훈
 - 백트래킹은 visited를 적극적으로 사용하자
 - 가능한 경우 set보다는 배열을 사용하자...? 🤔
 */

import Foundation

func solution(word: String) -> [String] {
    dfs(word: word.map { String($0) }).sorted()
}

func dfs(word: [String]) -> [String] {
    guard !word.isEmpty
    else {
        return [""]
    }

    var word = word, anagrams = [String](), visited = Set<String>()
    for (offset, char) in word.enumerated() {
        guard !visited.contains(char)
        else {
            continue
        }

        visited.insert(word.remove(at: offset))
        dfs(word: word).forEach { anagrams.append(char + $0) }
        word.insert(char, at: offset)
    }

    return anagrams
}

for _ in 0..<Int(readLine()!)! {
    print(solution(word: readLine()!).joined(separator: "\n"))
}
