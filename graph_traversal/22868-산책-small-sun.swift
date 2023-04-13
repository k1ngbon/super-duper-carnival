/*
- https://www.acmicpc.net/problem/22868
- 그래프 탐색(bfs)

생각 과정
- 일단 사전 순으로 가야되니까 시작 전에 edges를 파싱 후 정렬해줬다
- 그러고 나서 간선 가중치가 모두 1이므로 bfs~~~
  근데 경로를 효율적으로 기억하는 방법을 몰라서 처음에는 걍 큐에 경로 자체를 넣는 식으로 구현
- 메모리 초과 걱정했는데 통과~
- 다른 사람들 풀이를 보니까 visited 배열에 직전 노드를 저장하는 식으로 경로를 기록하고 백트래킹하길래
  나도 그렇게 변경! 메모리 절약 달달하다~
*/

import Foundation 

func solution(_ N: Int, _ edges: [[Int]], _ S: Int, _ E: Int) -> Int {
    let edges = parse(N, edges), new = -1
    var visited = Array(repeating: new, count: N + 1), answer = 0

    func bfs(start: Int, end: Int) {
        var queue = Queue([(start, start, 0)])

        while let (prev, node, dist) = queue.pop() {
            guard visited[node] == new
            else {
                continue
            }

            visited[node] = prev
            if node == end {
                answer += dist
                return
            }

            for next in edges[node] {
                queue.push((node, next, dist + 1))
            }
        }
    }

    func correctVisited(start: Int, end: Int) {
        var newVisited = Array(repeating: new, count: N + 1), node = end

        while visited[node] != start {
            node = visited[node]
            newVisited[node] += 1
        }

        visited = newVisited
    }
    
    bfs(start: S, end: E)
    correctVisited(start: S, end: E)
    bfs(start: E, end: S)

    return answer
}

private func parse(_ N: Int, _ edges: [[Int]]) -> [[Int]] {
    var array = Array(repeating: [Int](), count: N + 1)

    for edge in edges {
        let a = edge[0], b = edge[1]
        array[a].append(b)
        array[b].append(a)
    }
    return array.map { $0.sorted() }
}

var file = FileIO()
let N = file.readInt(), M = file.readInt()
var edges = [[Int]]()

for _ in 0..<M {
    edges.append([file.readInt(), file.readInt()])
}

let S = file.readInt(), E = file.readInt()

print(solution(N, edges, S, E))


struct Queue<T> {
    private var startIndex = 0
    private var endIndex = 0
    private var elements = [T]()

    init(_ elements: [T]) {
        self.elements = elements
        self.endIndex = elements.endIndex
    }

    mutating func push(_ element: T) {
        elements.append(element)
        endIndex += 1
    }

    mutating func pop() -> T? {
        guard startIndex != endIndex else { return nil }

        startIndex += 1
        return elements[startIndex - 1]
    }

    func print() {
        Swift.print((startIndex..<endIndex).map { elements[$0] })
    }
}

struct FileIO {
    private let buffer:[UInt8]
    private var index: Int = 0

    init(fileHandle: FileHandle = FileHandle.standardInput) {
        
        buffer = Array(try! fileHandle.readToEnd()!)+[UInt8(0)] // 인덱스 범위 넘어가는 것 방지
    }

    @inline(__always) private mutating func read() -> UInt8 {
        defer { index += 1 }

        return buffer[index]
    }

    @inline(__always) mutating func readInt() -> Int {
        var sum = 0
        var now = read()
        var isPositive = true

        while now == 10
                || now == 32 { now = read() } // 공백과 줄바꿈 무시
        if now == 45 { isPositive.toggle(); now = read() } // 음수 처리
        while now >= 48, now <= 57 {
            sum = sum * 10 + Int(now-48)
            now = read()
        }

        return sum * (isPositive ? 1:-1)
    }

    @inline(__always) mutating func readString() -> String {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return String(bytes: Array(buffer[beginIndex..<(index-1)]), encoding: .ascii)!
    }

    @inline(__always) mutating func readByteSequenceWithoutSpaceAndLineFeed() -> [UInt8] {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return Array(buffer[beginIndex..<(index-1)])
    }
}
