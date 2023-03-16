let firstInput = readLine()!.split(separator: " ").map { Int(String($0))! }
let (N, M) = (firstInput[0], firstInput[1])
var T: [Int] = []

for _ in 1...N {
    T.append(Int(readLine()!)!)
}
T.sort(by: <)

var left = 0, right = T.first! * M
var minTime = 0

while left <= right {
    let midTime = (left + right) / 2
    var passedPeople = 0
    
    for t in T {
        passedPeople += midTime / t
    }
    
    if passedPeople >= M {
        if minTime == 0 || minTime > midTime {
            minTime = midTime
        }
        right = midTime - 1
    } else {
        left = midTime + 1
    }
}

print(minTime)
