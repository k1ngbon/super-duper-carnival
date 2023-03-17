let firstInput = readLine()!.split(separator: " ").map { Int(String($0))! }
let (N, M, L) = (firstInput[0], firstInput[1], firstInput[2])
var positions: [Int] = [0]
if N > 0 {
    positions += readLine()!.split(separator: " ").map { Int(String($0))! }.sorted()
}
positions += [L]
var left = 1, right = L - 1
var maxLength = -1

while left <= right {
    let point = (left + right) / 2
    var count = 0
    
    for i in 1..<positions.count {
        let distance = positions[i] - positions[i - 1]
        if distance % point == 0 {
            count += (distance / point) - 1
        } else {
            count += (distance / point)
        }
    }
    
    if count <= M {
        right = point - 1
        maxLength = point
    } else {
        left = point + 1
    }
}

print(maxLength)

