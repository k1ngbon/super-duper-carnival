/*
 - https://www.acmicpc.net/problem/16234
 - 그래프 탐색(dfs)
 */

import Foundation

typealias Coordinate = (row: Int, col: Int)
typealias Union = (countries: [Coordinate], population: Int)

func solution(graph: [[Int]], lo: Int, hi: Int) -> Int {
    var time = 0, graph = graph

    // 1. find all unions in each loop
    while let unions = findAllUnions(in: graph, lo: lo, hi: hi) {
        // 2. move people in each union
        for (countries, population) in unions {
            let population = population / countries.count
            for (row, col) in countries {
                graph[row][col] = population
            }
        }
        time += 1
    }

    return time
}

func findAllUnions(in graph: [[Int]], lo: Int, hi: Int) -> [Union]? {
    let count = graph.count, dir = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    var unions = [Union]()
    var visited = Array(repeating: Array(repeating: false, count: count), count: count)

    for row in 0..<count {
        for col in 0..<count {

            guard !visited[row][col]
            else {
                continue
            }

            var union = Union([], 0), stack = [(row, col)]
            while let (row, col) = stack.popLast() {
                guard visited[row][col] == false
                else {
                    continue
                }

                visited[row][col].toggle()
                union.countries.append((row, col))
                union.population += graph[row][col]

                for (dr, dc) in dir {
                    let nr = row + dr, nc = col + dc
                    guard visited[safe: nr]?[safe: nc] == false,
                          lo...hi ~= abs(graph[nr][nc] - graph[row][col])
                    else {
                        continue
                    }

                    stack.append((nr, nc))
                }
            }

            if union.countries.count != 1 {
                unions.append(union)
            }
        }
    }

    return unions.isEmpty ? nil : unions
}

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
var graph = [[Int]]()

for _ in 0..<input[0] {
    graph.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(graph: graph, lo: input[1], hi: input[2]))
