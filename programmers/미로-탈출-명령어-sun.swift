/*
- https://school.programmers.co.kr/learn/courses/30/lessons/150365
- dfs
- 나는 원래 빡구현에 가까운 풀이로 풀었는데 다익스트라로 최단 경로 구한 다음에 이걸 활용하는 dp로 접근해보려다가 실패해서
  어쨌든 가장 짧은 경로가 최단 경로를 기반으로 하는 건 맞아서 여러가지 예외를 다 고려해서 최단 경로 계산하는 로직을 짰다... 
  근데 도출 과정도 너무 오래 걸리고 하나만 놓쳐도 바로 실수하기 좋아서 다른 사람들 풀이를 봤는데 dfs + 가지치기인거에요... 
- 가지를 어케치냐가 관건인데 일단 임의의 좌표에서 남은 이동 수(remain)와 해당 위치에서 탈출 위치까지의 최단 거리(shortestRoute)를 사용해야 한다. 
  임의의 점이 있으면 그냥 abs(end.x - x) + abs(end.y - y)가 최단 거리가 된다는 걸 생각을 못했는데 이거 생각한 분 천잰듯 ㄹㅇ
  암튼 불가능한 경로를 제거하기 위해 2가지로 가지치기를 해주는 데 임의의 한 좌표에서 
  1) (remain % 2 != shortestRoute)면 "원천적으로 탈출 불가"한 경우이므로 바로 중단한다 
    - 이거는 나도 깨달은? 조건이었는데 이렇게 간결하게 표현할 수 있다니... 
  2) (remain < shortestRoute)인 경우 문제의 조건인 "k회 안에 탈출 불가"한 경우이므로 바로 중단한다 
    - 이게 더 천재임 미쳤음.. 
  암튼 교훈은 걍 여러 경우의 수 중에 특정 조건을 만족하는 경로를 찾으라고 하면 가지치기를 어케할 지 고민하는 게 나을 듯 ㅠ 
*/

import Foundation

typealias Status = (x: Int, y: Int, count: Int, route: String)

func solution(_ n:Int, _ m:Int, _ x:Int, _ y:Int, _ r:Int, _ c:Int, _ k:Int) -> String {
    var stack = [Status(x: x, y: y, count: 0, route: "")]
    let dirs = [(1, 0, "d"), (0, -1, "l"), (0, 1, "r"), (-1, 0, "u")].reversed()

    while let status = stack.popLast() {
        if (status.x, status.y, status.count) == (r, c, k) {
            return status.route
        }

        let remain = k - status.count, shortestRoute = abs(status.x - r) + abs(status.y - c)
        guard 1...n ~= status.x,
              1...m ~= status.y,
              remain >= shortestRoute,
              remain % 2 == shortestRoute % 2
        else {
            continue
        }

        for (dx, dy, path) in dirs {
            stack.append(Status(
                x: status.x + dx,
                y: status.y + dy,
                count: status.count + 1,
                route: status.route + path
            ))
        }
    }

    return "impossible"
}
