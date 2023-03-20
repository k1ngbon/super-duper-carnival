// let input = readLine()!.split(separator: " ").map { Int(String($0))! }
/*
- https://www.acmicpc.net/problem/1749
- 누적합
- 근데 이거 카테별로 안 풀었으면 과연 나 혼자 생각했을까?ㅋㅎ
- 일단 행마다 누적합을 구해야겠다고는 생각했는데 그걸 어케 활용할까가 문제였음...
  단순 최대값끼리 합칠까 생각했는데 경우의 수가 너무 많아서 그건 불가능할것 같았다.. 
- 그러다가 2차원 누적합을 만들면 어떨까 하는 생각이 들어서 각 값이 자신을 끝 모서리로 하는 직사각형의 모든 값을 담고 있게 하면
  시작점과 끝점 사이의 직사각형의 누적합은 maxSumOf(start:end:) 메서드처럼 구할 수 있음을 도출했다. 
- 위 풀이는 시작점과 끝점을 확인하기 위해 4중 반복문..을 돌아야되는데 아슬아슬하게 통과할 수 있을 것 같아서 그대로 끝~
*/

import Foundation

typealias Coordinate = (r: Int, c: Int)

func solution(_ graph: [[Int]]) -> Int {
    let graph = graph.prefixSum()
    var maxSum = Int.min

    func maxSumOf(start: Coordinate, end: Coordinate) -> Int {
        let plus = graph[end.r][end.c] + (graph[safe: start.r - 1]?[safe: start.c - 1] ?? 0)
        let minus = (graph[safe: start.r - 1]?[end.c] ?? 0) + (graph[end.r][safe: start.c - 1] ?? 0)
        
        return plus - minus
    }

    for row in 0..<graph.count {
        for col in 0..<graph[0].count {
            for nr in row..<graph.count {
                for nc in col..<graph[0].count {
                    maxSum = max(maxSum, maxSumOf(start: (row, col), end: (nr, nc)))
                }
            }
        }
    }

    return maxSum
}

extension Array where Element == [Int] {
    func prefixSum() -> Self {
        var graph = [[Int]]()

        for row in self {
            var array = [Int](), sum = 0
            let prev = graph.last ?? Array<Int>(repeating: 0, count: self[0].count)

            for (index, number) in row.enumerated() {
                sum += number
                array.append(prev[index] + sum)
            }

            graph.append(array)
        }

        return graph
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var graph = [[Int]]()

for _ in 0..<input[0] {
  graph.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(graph))