/*
 - https://www.acmicpc.net/problem/1092
 - 그리디
 - 일단 매 기마다 각 크레인이 남은 박스 중에 자기가 들 수 있는 가장 무거운 박스를 옮기면 되겠구나 했는데 이건 시간이 너무
   오래 걸리지 않을까 하는 생각이 들었다...
 - 그래서 뭔가 단축해보려고 하다가 박스와 크레인을 무게가 큰 순서부터 정렬한 다음에,
   박스들을 돌면서 해당 박스를 들 수 있는 크레인 중에 누적된 박스가 제일 적은 크레인에 박스를 새로 추가하고,
   최종적으로 소요되는 시간은 가장 짐이 많은 크레인의 짐 개수이므로 max()를 사용해서 도출했다...
 - 근데 너무 복잡하게 생각한듯...ㅎ 걍 첨에 생각한 방식 그대로 구현해도 시간 초과 안 뜨는 것 같다^^
*/

import Foundation

func solution(cranes: [Int], boxes: [Int]) -> Int {
    var counts = Array(repeating: 0, count: cranes.count)
    let cranes = cranes.sorted(by: >), boxes = boxes.sorted(by: >)

    guard cranes[0] >= boxes[0]
    else {
        return -1
    }

    for box in boxes {
        var bestFitIndex = 0

        for index in 1..<cranes.endIndex {
            if cranes[index] < box {
                break
            }

            if counts[index] < counts[index - 1] {
                bestFitIndex = index
                break
            }
        }

        counts[bestFitIndex] += 1
    }

    return counts.max()!
}

let N = Int(readLine()!)!, cranes = readLine()!.split(separator: " ").map { Int(String($0))! }
let M = Int(readLine()!)!, boxes = readLine()!.split(separator: " ").map { Int(String($0))! }

print(solution(cranes: cranes, boxes: boxes))
