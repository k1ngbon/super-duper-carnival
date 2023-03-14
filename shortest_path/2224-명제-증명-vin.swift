let alphas: [String] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) } + "ABCDEFGHIJKLMNOPQRSTUVWXYZ".lowercased().map { String($0) }
let X = Int(readLine()!)!
var proved: [[Int]] = Array(repeating: Array(repeating: Int.max, count: 53), count: 53)
var printArray: [String] = []

for _ in 1...X {
    let input = readLine()!.split(separator: " ").map { String($0) }
    let preIndex = alphas.firstIndex(of: input[0])!
    let sufIndex = alphas.firstIndex(of: input[2])!
    proved[preIndex][sufIndex] = 1
}

for k in 0..<52 {
    for i in 0..<52 {
        for j in 0..<52 {
            if proved[i][k] == Int.max || proved[k][j] == Int.max { continue }
            if proved[i][j] > proved[i][k] + proved[k][j] {
                proved[i][j] = proved[i][k] + proved[k][j]
            }
        }
    }
}

for i in 0..<52 {
    for j in 0..<52 {
        if i == j || (proved[i][j] == Int.max) { continue }
        else {
            printArray.append("\(alphas[i]) => \(alphas[j])")
        }
    }
}

print(printArray.count)
for s in printArray {
    print(s)
}
