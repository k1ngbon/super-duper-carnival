/*
 - https://www.acmicpc.net/problem/3980
 - 백트래킹(dfs)
 - 뭔가 다른 사람들에 비해 엄청 비효율적으로 풀고 있는데...
 */

import Foundation

func solution(players: [[Int]]) -> Int {
    let stats = players
    let positions = players.map { Set($0.enumerated().compactMap { $0.element != 0 ? $0.offset : nil }) }
    var candidates = Array(repeating: Set<Int>(), count: 11)
    (0..<11).forEach { player in
        positions[player].forEach { candidates[$0].insert(player) }
    }

    func dfs(position: Int, candidates: [Set<Int>]) -> Int {
        guard position != 11
        else {
            return 0
        }

        var answer = -100 * 11
        for player in candidates[position] {
            var candidates = candidates

            for position in positions[player] {
                candidates[position].remove(player)
            }

            answer = max(answer, stats[player][position] + dfs(position: position + 1, candidates: candidates))
        }

        return answer
    }

    return dfs(position: 0, candidates: candidates)
}

let N = Int(readLine()!)!

for _ in 0..<N {
    var players = [[Int]]()
    for _ in 0..<11 {
        players.append(readLine()!.split(separator: " ").map { Int(String($0))! })
    }

    print(solution(players: players))
}
