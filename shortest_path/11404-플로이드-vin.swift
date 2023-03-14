let n = Int(readLine()!)!
let m = Int(readLine()!)!
var costs: [[Int]] = Array(repeating: Array(repeating: Int.max, count: n + 1), count: n + 1)

for _ in 1...m {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    let (a, b, c) = (input[0], input[1], input[2])
    costs[a][b] = min(costs[a][b], c)
}

for k in 1...n {
    for i in 1...n {
        for j in 1...n {
            if (i == j) || (costs[i][k] == Int.max || costs[k][j] == Int.max) { continue }
            if costs[i][k] + costs[k][j] < costs[i][j] {
                costs[i][j] = costs[i][k] + costs[k][j]
            }
        }
    }
}

for i in 1...n {
    var row = ""
    for j in 1...n {
        if costs[i][j] == Int.max { row += "0" }
        else { row += String(costs[i][j]) }
        if j < n { row += " "}
    }
    print(row)
}

