let N = Int(readLine()!)!
let K = Int(readLine()!)!
var position = readLine()!.split(separator: " ").map { Int(String($0))! }
var diff: [Int] = []
var length: Int = 0

position.sort()

for i in 1..<N {
    diff.append(position[i] - position[i - 1])
}

diff.sort()

if N >= K {
    for i in 0..<N-K {
        length += diff[i]
    }
} else {
    length = diff.reduce(0) { $0 + $1 }
}

print(length)

