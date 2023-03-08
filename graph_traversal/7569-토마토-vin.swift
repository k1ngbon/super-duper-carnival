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
let (M, N, H) = (firstInput[0], firstInput[1], firstInput[2])
let zyxPos = [[0, 0, 1], [0, 0, -1], [1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0]]
var tomatos: [[[Int]]] = Array(repeating: Array(repeating: Array(repeating: 0, count: M), count: N), count: H)
var queue: Queue<[Int]> = Queue([])
var days: Int = -1

for h in 0..<H {
    for n in 0..<N {
        let input = readLine()!.split(separator: " ").map { Int(String($0))! }
        tomatos[h][n] = input
    }
}

// 복수 개의 시작점 추가
for h in 0..<H {
    for n in 0..<N {
        for m in 0..<M {
            if tomatos[h][n][m] == 1 {
                queue.push([h, n, m])
            }
        }
    }
}

while !queue.isEmpty {
    let cnt = queue.count
    
    for _ in 1...cnt {
        guard let position = queue.pop()
        else { fatalError() }
        
        for pos in zyxPos {
            let zPos = position[0] + pos[0]
            let yPos = position[1] + pos[1]
            let xPos = position[2] + pos[2]
            
            if xPos >= 0 && xPos < M && yPos >= 0 && yPos < N && zPos >= 0 && zPos < H {
                if tomatos[zPos][yPos][xPos] == 0 {
                    queue.push([zPos, yPos, xPos])
                    tomatos[zPos][yPos][xPos] = 1
                }
            }
        }
    }
    
    days += 1
}

for h in 0..<H {
    for n in 0..<N {
        if tomatos[h][n].contains(0) { days = -1 }
    }
}

print(days)

