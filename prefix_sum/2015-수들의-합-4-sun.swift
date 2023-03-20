// let input = readLine()!.split(separator: " ").map { Int(String($0))! }
/*
- https://www.acmicpc.net/problem/2015
- 누적합
- 맨 첨에는 일단 i...j의 합은 prefix[j] - prefix[i - 1] 과 같으므로 
  i를 기준으로 반복문을 돌면서 j > i - 1 이고 prefix[j] - prefix[i - 1] == taret을 만족하는 j의 개수를 세면 되겠구나 했다
  시간초과 백퍼였는데 걍 해봤고 당연히 시간초과 ~~~~
- 그 다음에는 어차피 j의 개수만 알면 되니까 누적합을 구할 때 딕셔너리에 각 누적합의 개수를 기록해서
  만족하는 개수를 구할 때 딕셔너리 값을 사용하면 좀 시간이 단축되지 않을까 했음 근데 이러면 내가 찾는 값이 k라고 할때
  dict[k] 에서 (0...i-1) 범위에 있는 개수를 빼줘야 실제 유효한 값이 되는데 (0...i-1) 이거 완탐으로 찾는 방법밖에 생각이 안났음
  그러니까 당연히 또 시간초과
- 그러다가 문득 어차피 반복문을 돌면서 지나간 값은 그 다음에는 못 쓰는 값이니까 딕셔너리에서 제거해주면 되겠다는 생각이 들었고
  그래서 26번 줄을 추가했더니 드디어 통과~~~~ 근데 이걸 좀 더 빠르고 효율적으로 생각할 수는 없을까ㅠ 엄청 오래 걸렸다.. 
- 교훈은 정말 감이 안오면 일단 시간 초과 나는 코드부터 작성하고 어디를 개선할 수 있을 지 고민하자?
*/

import Foundation

func solution(numbers: [Int], target: Int) -> Int {
    var (sum, dict) = numbers.prefixSum()
    var count = sum.filter { $0 == target }.count
    dict[sum[0]]! -= 1

    for index in 1..<numbers.endIndex {
        count += dict[target + sum[index - 1], default: 0]
        dict[sum[index]]! -= 1
    }

    return count
}

extension Array where Element == Int {
    func prefixSum() -> (Self, [Int: Int]) {
    
        var array = [Int](), dict = [Int: Int]()
        
        for number in self {
            let sum = (array.last ?? 0) + number
            array.append(sum)
            dict[sum, default: 0] += 1
        }

        return (array, dict)
    }
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let numbers = readLine()!.split(separator: " ").map { Int(String($0))! }
print(solution(numbers: numbers, target: input[1]))