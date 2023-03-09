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

let firstInput = readLine()!.split(separator: " ").map { Int(String($0))! }
let (N, L, R) = (firstInput[0], firstInput[1], firstInput[2])
let position: [(x: Int, y: Int)] = [(-1, 0), (1, 0), (0, -1), (0, 1)]
var A: [[Int]] = []
var arePeopleMoving: Bool = true
var days: Int = -1

for _ in 1...N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    A.append(input)
}

while arePeopleMoving {
    var queue: Queue<(x: Int, y: Int)> = Queue<(x: Int, y: Int)>()
    var hasVisited: [[Bool]] = Array(repeating: Array(repeating: false, count: N + 1), count: N + 1)
    arePeopleMoving = false
    days += 1
    
    for i in 0..<N {
        for j in 0..<N {
            if hasVisited[i][j] { continue }
            var unionCountries: [(x: Int, y: Int)] = []
            var totalPeopleCount: Int = 0
            var countriesCount: Int = 0
            
            queue.push((i, j))
            unionCountries.append((i, j))
            hasVisited[i][j] = true
            totalPeopleCount = A[i][j]
            countriesCount = 1
            
            while !queue.isEmpty {
                guard let pos = queue.pop()
                else { fatalError() }
                
                for (x, y) in position {
                    let xPos = x + pos.x
                    let yPos = y + pos.y
                    
                    if xPos >= 0 && xPos < N && yPos >= 0 && yPos < N {
                        if hasVisited[xPos][yPos] { continue }
                        
                        let currentPeopleCount = A[pos.x][pos.y]
                        let unionPeopleCount = A[xPos][yPos]
                        let count = abs(currentPeopleCount - unionPeopleCount)
                        
                        if count >= L && count <= R {
                            arePeopleMoving = true
                            queue.push((xPos, yPos))
                            unionCountries.append((xPos, yPos))
                            hasVisited[xPos][yPos] = true
                            totalPeopleCount += A[xPos][yPos]
                            countriesCount += 1
                        }
                    }
                }
            }
            
            let editedPeopleCount = totalPeopleCount / countriesCount
            if countriesCount > 1 {
                for pos in unionCountries {
                    A[pos.x][pos.y] = editedPeopleCount
                }
            }
        }
    }
}

print(days)
