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

let firstLine = readLine()!.split(separator: " ").map { Int(String($0))! }
let (N, K) = (firstLine[0], firstLine[1])
let MAX = 100000
var queue: Queue<(pos: Int, time: Int)> = Queue<(pos: Int, time: Int)>()
var checkedPosition: [Bool] = Array(repeating: false, count: 2 * MAX + 1)
var fastestTime: Int = MAX

if N == K {
    print(0)
} else {
    queue.push((N * 2, 0))
    checkedPosition[N * 2] = true
    if N > 0 {
        queue.push((N - 1, 1))
        checkedPosition[N - 1] = true
    }
    queue.push((N + 1, 1))
    checkedPosition[N + 1] = true

    while !queue.isEmpty {
        guard let move = queue.pop()
        else { fatalError() }
        
        if move.pos == K {
            fastestTime = min(fastestTime, move.time)
        } else {
            if move.pos * 2 >= 0 && move.pos * 2 <= MAX && !checkedPosition[move.pos * 2] {
                queue.push((move.pos * 2, move.time))
                checkedPosition[move.pos * 2] = true
            }
            if move.pos - 1 >= 0 && move.pos - 1 <= MAX && !checkedPosition[move.pos - 1] {
                queue.push((move.pos - 1, move.time + 1))
                checkedPosition[move.pos - 1] = true
            }
            if move.pos + 1 >= 0 && move.pos + 1 <= MAX && !checkedPosition[move.pos + 1] {
                queue.push((move.pos + 1, move.time + 1))
                checkedPosition[move.pos + 1] = true
            }
        }
    }

    print(fastestTime)
}
