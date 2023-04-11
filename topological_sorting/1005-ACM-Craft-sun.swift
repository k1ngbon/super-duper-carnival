/*
- https://www.acmicpc.net/problem/1005
- 위상정렬
- 시간초관데 입출력 바꾸기 싫어서 걍...고... 
- 처음에 배열 초기화 잘못해서 시간 날림
*/

import Foundation

private func solution(_ times: [Int], _ indegree: [Int], _ edges: [[Int]], _ target: Int) -> Int {
    var indegree = indegree
    let starts = indegree.enumerated().compactMap { $0.element == 0 ? ($0.offset, times[$0.offset]) : nil }
    var queue = Queue(starts)
    var endTime = times

    while let (index, time) = queue.pop() {
        if index == target {
            break
        }
        
        for next in edges[index] {
            indegree[next] -= 1
            endTime[next] = max(endTime[next], time + times[next])
            if indegree[next] == 0 {
                queue.push((next, endTime[next]))
            }
        }
    }

    return endTime[target]
}

var answers = [Int]()
for _ in 0..<Int(readLine()!)! {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    let N = input[0], K = input[1]
    let times = readLine()!.split(separator: " ").map { Int(String($0))! }
    var indegree = Array(repeating: 0, count: N), edges = Array(repeating: [Int](), count: N)

    for _ in 0..<K {
        let input = readLine()!.split(separator: " ").map { Int(String($0))! }
        let pre = input[0] - 1, post = input[1] - 1
        indegree[post] += 1
        edges[pre].append(post)
    }
    
    answers.append(solution(times, indegree, edges, Int(readLine()!)! - 1))
}

print(answers.map { String($0) }.joined(separator: "\n"))

struct Queue<Element> {
    private var elements = [Element]()
    private var startIndex = 0
    private var endIndex = 0

    init(_ elements: [Element]) {
        self.elements = elements
        self.endIndex = elements.endIndex
    }

    mutating func push(_ element: Element) {
        elements.append(element)
        endIndex += 1
    }

    mutating func pop() -> Element? {
        guard startIndex != endIndex
        else {
            return nil
        }

        startIndex += 1
        return elements[startIndex - 1]
    }
}