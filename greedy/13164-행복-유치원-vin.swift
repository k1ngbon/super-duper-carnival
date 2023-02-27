let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let children: [Int] = readLine()!.split(separator: " ").map { Int(String($0))! }
let (N, K) = (input[0], input[1])
var diff: [Int] = []
var cost: Int = 0

for i in 1..<N {
    diff.append(children[i] - children[i - 1])
}

diff.sort()

for i in 0..<N-K {
    cost += diff[i]
}

print(cost)
