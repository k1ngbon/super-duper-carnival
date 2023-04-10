/*
- https://www.acmicpc.net/problem/2141
- 그리디

생각 과정
- 처음에는 sum(위치 * 인원) / 전체 인원 을 내림한 값이 답이라고 생각했는데 일단 틀렸다
- 솔루션을 보고 깨달은 가장 중요한 사항은 우체국의 위치가 항상 도시 중 하나라는 것!
  [1, 1], [3, 1] 이렇게 주어지는 경우 나는 당연히 중점인 2라고 생각했는데 1이어도 결과가 같고 
  결과가 같으면 작은 값을 쓰라고 했으므로 답은 1이었다... 
- 암튼 저거에 기반하면 좀 단순하게 문제를 해석할 수 있는데 그냥 도시를 순차적으로 돌면서 인원을 더하고
  인원이 전체의 절반 이상인 경우 해당 우체국에 설치하면 된다 
- 이 때 주의할 점은 인원이 홀수인 경우를 처리해줘야 한다는 것...! 처음에 틀렸다가 halfPopulation 도출을 변경했다

기타
- 가장 작은 것을 리턴하라와 같은 지시문이 있으면 그게 힌트니까 주의할 것!
- 손으로 직접 써보면서 풀이했으면 스스로 떠올렸을지도..? 
*/

import Foundation

private func solution(_ countries: [[Int]]) -> Int {
    let halfPopulation = (countries.reduce(0) { $0 + $1[1] } + 1) / 2
    let countries = countries.sorted { $0[0] < $1[0] }
    var currentSum = 0

    for country in countries {
        currentSum += country[1]
        if currentSum >= halfPopulation {
            return country[0]
        }
    }

    return -1
}

var countries = [[Int]]()

for _ in 0..<Int(readLine()!)! {
    countries.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(countries))

