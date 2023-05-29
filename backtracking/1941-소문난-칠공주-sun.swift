/*
- https://www.acmicpc.net/problem/1941
- 완탐

# 생각과정
- 백트래킹...백트래킹...단순히 오른쪽이랑 아래만 추가 탐색해볼까? 
  근데 이렇게 하면 누락되는 케이스가 너무 많음... 
- 백트래킹은 솔직히 모르겠고 경우의 수 계산해보니까 완탐 돌려도 풀릴듯?!
- 모든 조합을 만든 다음에 1) 7명 모두 인접한지 2) 다솜파가 우위인지 확인하면 될듯? 
- 7명 모두 인접한 걸 대체 어케 구하지...? 효율적으로 못하겠어... 
  걍 반복문 오지게 돌려도 시간초과 안나니까 무한 반복문 돌리자....
*/

import Foundation

typealias Graph = [[String]]

var graph = Graph()

for _ in 0..<5 {
    graph.append(readLine()!.map { String($0) })
}

print(solution(graph))


extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

struct Coordinate: Hashable, CustomStringConvertible {
    let r: Int
    let c: Int

    var description: String {
        "(\(r), \(c))"
    }

    init(_ r: Int, _ c: Int) {
        self.r = r
        self.c = c
    }

    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        .init(lhs.r + rhs.r, lhs.c + rhs.c)
    }
}

func solution(_ graph: Graph) -> Int {
    let dasom = "S", dir: [Coordinate] = [.init(0, 1), .init(0, -1), .init(1, 0), .init(-1, 0)]
    var graph = graph, count = 0

    func findSevenPrincesses(index: Int = 0, girls: [Coordinate] = []) {
        guard girls.count != 7
        else {
            count += isValid(girls) ? 1 : 0
            return
        }

        for index in index..<25 {
            let row = index / 5, col = index % 5
            findSevenPrincesses(index: index + 1, girls: girls + [.init(row, col)])
        }
    }

    func isValid(_ girls: [Coordinate]) -> Bool {
        var girls = girls, cluster = [girls.removeLast()], neighbors = Set(dir.map { cluster.last! + $0 })

        while !girls.isEmpty {
            guard let index = girls.firstIndex(where: { neighbors.contains($0) })
            else {
                return false
            }

            let princess = girls.remove(at: index)
            neighbors.formUnion(dir.map { princess + $0 })
            cluster.append(princess)
        }

        return cluster.reduce(0) { $0 + (graph[$1.r][$1.c] == dasom ? 1 : -1) } > 0
    }

    findSevenPrincesses()
    return count
}
