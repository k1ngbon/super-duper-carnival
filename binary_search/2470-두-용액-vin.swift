// 이왜이분탐색?

let N = Int(readLine()!)!
var density: [Int] = readLine()!.split(separator: " ").map { Int(String($0))! }.sorted()
var left = 0, right = density.count - 1
var leftSolution = -1, rightSolution = -1, minDensity = Int.max

while left < right {
    let mixed = density[left] + density[right]

    if abs(mixed) <= abs(minDensity) {
        minDensity = mixed
        leftSolution = density[left]
        rightSolution = density[right]
    }

    if mixed == 0 {
        break
    }

    if mixed < 0 {
        left += 1
    } else {
        right -= 1
    }
}

print("\(leftSolution) \(rightSolution)")

