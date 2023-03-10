class Queue<T> {
    var enqueue: [T] = []
    var dequeue: [T] = []
    
    var isEmpty: Bool {
        return enqueue.isEmpty && dequeue.isEmpty
    }
    
    var count: Int {
        return enqueue.count + dequeue.count
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

let oddX = [-1, 1, 0, 1, 0, 1]
let oddY = [ 0, 0, 1, 1,-1,-1]
let evenX = [-1, 1, -1, 0, 0,-1]
let evenY = [ 0, 0, -1,-1, 1, 1]

let firstInput = readLine()!.split(separator: " ").map{ Int(String($0))! }
let (N, M) = (firstInput[0], firstInput[1])
var map: [[Int]] = []
var queue: Queue<[Int]> = Queue<[Int]>()
var hasVisited: [[Bool]] = Array(repeating: Array(repeating: false, count: N + 2), count: M + 2)
var length: Int = 0

for c in 1...M {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    if c == 1 { map.append(Array(repeating: 0, count: N + 2)) }
    map.append([0] + input + [0])
    if c == M { map.append(Array(repeating: 0, count: N + 2))}
}

queue.push([0, 0])
hasVisited[0][0] = true

while !queue.isEmpty {
    guard let pos = queue.pop()
    else { fatalError() }
    
    // 짝수, 홀수에 따라 다름
    if pos[0] % 2 == 0 {
        for idx in 0..<6 {
            let xPos = pos[1] + evenX[idx]
            let yPos = pos[0] + evenY[idx]
            
            if xPos >= 0 && xPos < N + 2 && yPos >= 0 && yPos < M + 2 {
                if map[yPos][xPos] == 0 && !hasVisited[yPos][xPos] {
                    queue.push([yPos, xPos])
                    hasVisited[yPos][xPos] = true
                } else if map[yPos][xPos] == 1 {
                    length += 1
                }
            }
        }
    } else {
        for idx in 0..<6 {
            let xPos = pos[1] + oddX[idx]
            let yPos = pos[0] + oddY[idx]
            
            if xPos >= 0 && xPos < N + 2 && yPos >= 0 && yPos < M + 2 {
                if map[yPos][xPos] == 0 && !hasVisited[yPos][xPos] {
                    queue.push([yPos, xPos])
                    hasVisited[yPos][xPos] = true
                } else if map[yPos][xPos] == 1 {
                    length += 1
                }
            }
        }
    }
}

print(length)

