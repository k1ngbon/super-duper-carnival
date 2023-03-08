// Queue 안하고 배열로 하면시간초과..

class Queue<T> {
    var enqueue: [T] = []
    var dequeue: [T] = []

    var isEmpty: Bool {
        return enqueue.isEmpty && dequeue.isEmpty
    }

    var count: Int {
        return enqueue.count + dequeue.count
    }

    init(_ queue: [T]) {
        enqueue = queue
    }

    func push(_ node: T) {
        enqueue.append(node)
    }

    func pop() -> T? {
        if dequeue.isEmpty {
            dequeue = enqueue.reversed()
            enqueue.removeAll()
        }

        return dequeue.popLast()
    }
}

let firstInput = readLine()!.split(separator: " ").map { Int(String($0))! }
let (M, N) = (firstInput[0], firstInput[1])
let xyPos = [[-1, 0], [1, 0], [0, -1], [0, 1]]
var tomatos: [[Int]] = []
var queue: Queue<[Int]> = Queue([])
var days: Int = -1

for _ in 1...N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    tomatos.append(input)
}

// 맨 처음 시작 토마토 찾기, 복수 개의 시작점 있을 수 있음
for i in 0..<N {
    for j in 0..<M {
        if tomatos[i][j] == 1 { queue.push([i, j]) }
    }
}

while !queue.isEmpty {
    let n = queue.count

    for _ in 1...n {
        guard let position = queue.pop()
        else { fatalError() }

        for pos in xyPos {
            let xPos = position[0] + pos[0]
            let yPos = position[1] + pos[1]

            if xPos >= 0 && xPos < N && yPos >= 0 && yPos < M {
                if tomatos[xPos][yPos] == 0 {
                    queue.push([xPos, yPos])
                    tomatos[xPos][yPos] = 1
                }
            }
        }
    }

    days += 1
}

// 시간 다 지났는데 안 익은 토마토 있으면 -1
for tomato in tomatos {
    if tomato.contains(0) { days = -1 }
}

print(days)
