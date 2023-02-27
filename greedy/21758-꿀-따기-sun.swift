/*
 - https://www.acmicpc.net/problem/21758
 - 그리디/누적합
 - N이 마지막 인덱스일 때 (벌, 벌, 벌집)의 경우의 수를 따져봤을 때 항상 답이 셋 중 하나의 경우에 해당됐다
     1) (0, i, N) 단 i < N
     2) (0, N, k) 단, 0 < k < N
     3) (i, N, 0) 단, i < N
 - 그래서 각 경우를 잘 계산해주면 된다고 생각해서 i를 구하는 공식을 도출했는데 아마도 이게 틀렸는지 계속 틀렸습니다가 떴다..
   결국 해설 봤는데 걍 완탐마냥 다 확인하길래 바~로 베낌
 - 누적합에 대해서 처음 본 거 같은데 다음에 비슷한 문제를 만나면 어케 누적합을 떠올릴 수 있을 지 모르겠음... 
*/

import Foundation

func solution(honey: [Int]) -> Int {
    var sum = [honey.first!]

    for index in 1..<honey.endIndex {
        sum.append(honey[index] + sum[index - 1])
    }

    // 1. bee hive bee
    var maxHoney = sum[honey.endIndex - 2] - honey.first! + (1..<honey.endIndex).reduce(0) { max($0, honey[$1])}

    // 2. bee bee hive
    for index in 1..<honey.endIndex - 1 {
        let currenHoney = sum.last! - honey.first! - honey[index] + sum.last! - sum[index]
        maxHoney = max(maxHoney, currenHoney)
    }

    // 3. hive bee bee
    for index in 1..<honey.endIndex - 1{
        let currentHoney = sum.last! - honey.last! - honey[index] + sum[index - 1]
        maxHoney = max(maxHoney, currentHoney)
    }

    return maxHoney
}

let _ = Int(readLine()!)!
let honey = readLine()!.split(separator: " ").map { Int(String($0))! }

print(solution(honey: honey))
