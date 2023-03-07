let firstInput = readLine()!.split(separator: " ").map { Int(String($0))! }
let (N, M) = (firstInput[0], firstInput[1])
var wood: [[Int]] = []
var used: [[Bool]] = Array(repeating: Array(repeating: false, count: M), count: N)
var hard: [Int] = []

for _ in 1...N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    wood.append(input)
}

if N == 1 || M == 1 {
    print(0)
} else {
    makeBoomerang(with: (0, 0), 0)
    print(hard.max()!)
}

func makeBoomerang(with index: (i: Int, j: Int), _ sum: Int) {
    var (i, j) = (index.i, index.j)
    
    // j 범위 끝
    if (j == M) {
        j = 0
        i += 1
    }
    // i 범위 끝
    if (i == N) {
        hard.append(sum)
        return
    }
    
    if !used[i][j] {
        if j + 1 < M && i + 1 < N && !used[i][j + 1] && !used[i + 1][j] {
            let h = wood[i][j] * 2 + wood[i][j + 1] + wood[i + 1][j]
            used[i][j] = true; used[i][j + 1] = true; used[i + 1][j] = true
            makeBoomerang(with: (i, j + 1), sum + h)
            used[i][j] = false; used[i][j + 1] = false; used[i + 1][j] = false
        }
        if j - 1 >= 0 && i + 1 < N && !used[i][j - 1] && !used[i + 1][j] {
            let h = wood[i][j] * 2 + wood[i][j - 1] + wood[i + 1][j]
            used[i][j] = true; used[i][j - 1] = true; used[i + 1][j] = true
            makeBoomerang(with: (i, j + 1), sum + h)
            used[i][j] = false; used[i][j - 1] = false; used[i + 1][j] = false
        }
        if i - 1 >= 0 && j + 1 < M && !used[i - 1][j] && !used[i][j + 1] {
            let h = wood[i][j] * 2 + wood[i - 1][j] + wood[i][j + 1]
            used[i][j] = true; used[i - 1][j] = true; used[i][j + 1] = true
            makeBoomerang(with: (i, j + 1), sum + h)
            used[i][j] = false; used[i - 1][j] = false; used[i][j + 1] = false
        }
        if i - 1 >= 0 && j - 1 >= 0 && !used[i - 1][j] && !used[i][j - 1] {
            let h = wood[i][j] * 2 + wood[i - 1][j] + wood[i][j - 1]
            used[i][j] = true; used[i - 1][j] = true; used[i][j - 1] = true
            makeBoomerang(with: (i, j + 1), sum + h)
            used[i][j] = false; used[i - 1][j] = false; used[i][j - 1] = false
        }
    }
    
    makeBoomerang(with: (i, j + 1), sum)
}
