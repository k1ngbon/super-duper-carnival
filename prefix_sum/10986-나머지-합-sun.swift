// let input = readLine()!.split(separator: " ").map { Int(String($0))! }
/*
- https://www.acmicpc.net/problem/status/10986
- 일단 N^2 풀이만 생각나서 어케 줄이지 어케 줄이지 하면서 이것저것 해보다가 모듈러 연산(%) 값이 같은 애들끼리 빼주면 된다는 것을 꺠달음
- 그래서 앞에서부터 순회하면서 딕셔너리에 해당 숫자의 모듈러 값의 개수를 하나씩 업데이트 해주는 방식으로 접근
- 숫자가 음수인 경우를 따지는 게 복잡했는데 다른 사람들 풀이 보니까 비슷한데 더 단순한 접근이 있는듯...?
*/
import Foundation

func solution(array: [Int], divider: Int) -> Int {
    let prefixSum = array.prefixSum()
    var dict = [Int: Int](), count = 0

    for element in prefixSum {
        let remainder = element % divider < 0 ? divider - abs(element % divider) : element % divider 
        count += dict[remainder, default: 0] + (remainder == 0 ? 1 : 0)
        dict[remainder, default: 0] += 1
    }

    return count
}

extension Array where Element == Int {
    func prefixSum() -> Self {
        var array = [Int]()
        
        for element in self {
            array.append(element + (array.last ?? 0))
        }

        return array
    }
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let array = readLine()!.split(separator: " ").map { Int(String($0))! }
print(solution(array: array, divider: input[1]))