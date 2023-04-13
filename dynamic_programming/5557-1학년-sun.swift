/*
- https://www.acmicpc.net/problem/5557
- DP

생각 과정
- 새로운 숫자 하나가 더 추가되었을 때 합으로 target을 만들 수 있으려면 +- 하는 경우를 각각 고려하기 위해 
  graph[index - 1][target - number] 와 graph[index - 1][target + number] 를 더하면 된다 
  이때 중간값이 항상 0...20 이어야 하므로 열의 크기를 0...20으로 제한해주고 index out of range 잘 체크하기!
- 중간에 맨 앞에 숫자를 따로 처리해줘야되나 생각했다가 상관없다고 착각했는데 맨 앞에 0이 오는 경우 때문에 따로 해줬어야 됐다 바보.. 
*/

import Foundation

private let (start, end) = (0, 20)

func solution(_ numbers: [Int]) -> Int {
    var numbers = numbers, target = numbers.removeLast()
    // graph[index][target] = numbers[index] 가 새로 추가되었을 때 합으로 target을 만들 수 있는 경우의 수 
    var graph = Array(repeating: Array(repeating: 0, count: 20 + 1), count: numbers.count)
    graph[0][numbers[0]] = 1
    for index in 1..<numbers.count {
        let number = numbers[index]
        for target in 0...20 {
            graph[index][target] = (graph[index - 1][safe: target - number] ?? 0) + (graph[index - 1][safe: target + number] ?? 0)
        }
    }

    return graph.last![target]
}

fileprivate extension Array {
    subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

let _ = readLine()
print(solution(readLine()!.split(separator: " ").map { Int(String($0))! }))
