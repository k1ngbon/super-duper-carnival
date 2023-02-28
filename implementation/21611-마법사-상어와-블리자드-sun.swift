/*
 - https://www.acmicpc.net/problem/21611
 - 구현
 - 미친거야 진짜 이런 걸 내면...
 - 그래프 상태로는 연산이 너무 복잡해 보여서 매 기마다 그래프 -> 배열로 변경해서 연산하고 마지막에 업데이트 된 배열의 데이터로
   그래프도 업데이트 해 주는 방식으로 접근했다...
 */

import Foundation

typealias Magic = (direction: Int, distance: Int)

struct Marble: Hashable {
    let id: Int
    let type: Int
}

func solution(N: Int, graph: [[Marble]], magic: [Magic]) -> Int {
    let shark = (N + 1) / 2 - 1
    var bursts = Array(repeating: 0, count: 4)

    // form marble array
    var marbles = graphToArray(graph: graph, N: N, shark: shark)
    var graph = arrayToGraph(marbles: marbles, N: N, shark: shark)

    for (dir, dist) in magic {
        // 1. do magic
        blizarrdMagic(shark: shark, dir: dir, dist: dist, marbles: &marbles, graph: &graph)

        // 2. check and count bursts
        burstMarbles(&marbles, bursts: &bursts)

        // 3. marble transition
        marbles = transformedMarbles(marbles, N: N)

        // 4. form new graph with new marble array
        graph = arrayToGraph(marbles: marbles, N: N, shark: shark)
    }

    return bursts.enumerated().reduce(0) { $0 + $1.element * $1.offset }
}

func printMarbles(_ marbles: [Marble], N: Int) {
    let graph = arrayToGraph(marbles: marbles, N: N, shark: (N + 1) / 2 - 1)
    graph.forEach { print($0.map { $0?.type ?? 0 })}
    print("")
}

func graphToArray(graph: [[Marble]], N: Int, shark: Int) -> [Marble] {
    let directions = [(0, -1), (1, 0), (0, 1), (-1, 0)]
    var marbles = [Marble]()
    var row = shark, col = shark, len = 1, cnt = 0, dir = 0

    for id in 0..<N * N - 1 {
        let (dr, dc) = directions[dir]
        row += dr
        col += dc

        let type = graph[row][col].type
        guard type != 0
        else {
            break
        }

        marbles.append(.init(id: id, type: type))
        cnt += 1

        guard len == cnt
        else {
            continue
        }

        cnt = 0
        len += dir % 2
        dir = (dir + 1) % 4
    }

    return marbles
}

func arrayToGraph(marbles: [Marble], N: Int, shark: Int) -> [[Marble?]] {
    var graph = Array(repeating: Array(repeating: Marble?.none, count: N), count: N)
    let directions = [(0, -1), (1, 0), (0, 1), (-1, 0)]
    var row = shark, col = shark, len = 1, cnt = 0, dir = 0

    for marble in marbles {
        let (dr, dc) = directions[dir]
        row += dr
        col += dc

        graph[row][col] = marble
        cnt += 1

        guard len == cnt
        else {
            continue
        }

        cnt = 0
        len += dir % 2
        dir = (dir + 1) % 4
    }

    return graph
}


func transformedMarbles(_ marbles: [Marble], N: Int) -> [Marble] {
    guard !marbles.isEmpty
    else {
        return []
    }

    var transformed = [Marble](), prev = marbles.first!.type, count = 1, id = 0

    for index in 1..<marbles.endIndex {
        let marble = marbles[index]
        guard transformed.count < N * N - 1
        else {
            break
        }

        guard marble.type != prev
        else {
            count += 1
            continue
        }

        transformed.append(.init(id: id, type: count))
        transformed.append(.init(id: id + 1, type: prev))
        id += 2
        prev = marble.type
        count = 1
    }

    transformed.append(.init(id: id, type: count))
    transformed.append(.init(id: id + 1, type: prev))
    transformed.removeLast(max(0, transformed.count + 1 - N * N))

    return transformed
}

func burstMarbles(_ marbles: inout [Marble], bursts: inout [Int]) {
    var hasBurst = true

    while hasBurst {
        hasBurst = false
        var prevType = -1, count = 0, burst = Set<Marble>(), candiates = Set<Marble>()

        for marble in marbles {
            guard marble.type == prevType
            else {
                prevType = marble.type
                count = 1
                candiates = [marble]
                continue
            }

            count += 1
            if count < 4 {
                candiates.insert(marble)
                continue
            }

            if count == 4 {
                burst.formUnion(candiates)
                candiates.removeAll()
                hasBurst = true
            }

            burst.insert(marble)
        }

        marbles.removeAll { burst.contains($0) }

        for marble in burst {
            bursts[marble.type] += 1
        }
    }
}

func blizarrdMagic(shark: Int, dir: Int, dist: Int, marbles: inout [Marble], graph: inout [[Marble?]]) {
    let directions = [(0, 0), (-1, 0), (1, 0), (0 , -1), (0, 1)]
    let (dr, dc) = directions[dir]

    // 1. do magic
    var destroyed = Set<Marble>()

    for times in 1...dist {
        guard let marble = graph[shark + times * dr][shark + times * dc]
        else {
            continue
        }

        destroyed.insert(marble)
    }

    marbles.removeAll { destroyed.contains($0) }
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let N = input[0], M = input[1]
var graph = [[Marble]](), magic = [Magic]()

for _ in 0..<N {
    graph.append(readLine()!.split(separator: " ").map { Marble(id: 0, type: Int(String($0))!) })
}

for _ in 0..<M {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    magic.append((input[0], input[1]))
}

print(solution(N: N, graph: graph, magic: magic))
