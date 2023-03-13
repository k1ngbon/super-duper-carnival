// Sol1.
// 딕셔너리 배열로 만들었다가 시간초과떠서 2중 배열로 바꿈
let firstInput = readLine()!.split(separator: " ").map{ Int(String($0))! }
let (N, M) = (firstInput[0], firstInput[1])
var time: [[Int]] = []

for _ in 1...N {
    let input1 = readLine()!.split(separator: " ").map { Int(String($0))! }
    time.append(input1)
}

// A->B 직통 말고 경유해서 가는 최솟값 있는지 확인
// 플로이드 워셜
for k in 0..<N {
    for i in 0..<N {
        for j in 0..<N {
            if time[i][j] > time[i][k] + time[k][j] {
                time[i][j] = time[i][k] + time[k][j]
            }
        }
    }
}

for _ in 1...M {
    let input2 = readLine()!.split(separator: " ").map { Int(String($0))! }
    let (A, B, C) = (input2[0], input2[1], input2[2])

    if time[A - 1][B - 1] <= C {
        print("Enjoy other party")
    } else {
        print("Stay here")
    }
}
 

// Sol2.
// 딕셔너리 + 배열로 풀기.. 오히려 시간은 더 걸렸다고 한다
let firstInput = readLine()!.split(separator: " ").map{ Int(String($0))! }
let (N, M) = (firstInput[0], firstInput[1])
var time: [[Int: Int]] = Array(repeating: [:], count: N + 1)
var minTime: [[Int]] = []

for i in 1...N {
    let input1 = readLine()!.split(separator: " ").map { Int(String($0))! }
    minTime.append(input1)
    for (j, t) in input1.enumerated() {
        time[i][j + 1] = t
    }
}

// A->B 직통 말고 경유해서 가는 최솟값 있는지 확인
// 플로이드 워셜
for k in 0..<N {
    for i in 0..<N {
        for j in 0..<N {
            if minTime[i][j] > minTime[i][k] + minTime[k][j] {
                minTime[i][j] = minTime[i][k] + minTime[k][j]
            }
        }
    }
}

for _ in 1...M {
    let input2 = readLine()!.split(separator: " ").map { Int(String($0))! }
    let (A, B, C) = (input2[0], input2[1], input2[2])
    
    if time[A][B]! <= C {
        print("Enjoy other party")
    } else {
        if minTime[A - 1][B - 1] <= C {
            print("Enjoy other party")
        } else {
            print("Stay here")
        }
    }
}
