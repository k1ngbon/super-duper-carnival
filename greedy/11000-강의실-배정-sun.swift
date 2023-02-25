/*
 - https://www.acmicpc.net/problem/11000
 - 그리디(우선순위 큐)
 - 직접 구현한 우선순위 큐 너무 느려서 다시 구현해야 되는데...쉽지 않다...ㅎ
*/

import Foundation

typealias Schedule = (start: Int, end: Int)

struct MinHeap<T: Comparable> {
    var heap: [T] = []

    var isEmpty: Bool {
        return heap.count <= 1 ? true : false
    }
    var count: Int {
        heap.count - 1
    }

    init() {}
    init(_ element: T) {
        heap.append(element) // 0번 index채우기 용
        heap.append(element) // 실제 Root Node 채움.
    }

    mutating func push(_ element: T) {
        if heap.isEmpty {
            heap.append(element)
            heap.append(element)
            return
        }
        heap.append(element)

        func isMoveUp(_ insertIndex: Int) -> Bool {
            if insertIndex <= 1 { // Root Node일 때,
                return false
            }
            let parentIndex = insertIndex / 2
            return heap[insertIndex] < heap[parentIndex] ? true : false
        }

        var insertIndex = heap.count - 1
        while isMoveUp(insertIndex) {
            let parentIndex = insertIndex / 2
            heap.swapAt(insertIndex, parentIndex)
            insertIndex = parentIndex
        }
    }

    enum moveDownStatus { case left, right, none }

    mutating func pop() -> T? {
        if heap.count <= 1 {
            return nil
        }
        let returnData = heap[1]
        heap.swapAt(1, heap.count - 1)
        heap.removeLast()

        func moveDown(_ poppedIndex: Int) -> moveDownStatus {
            let leftChildIndex = poppedIndex * 2
            let rightChildIndex = leftChildIndex + 1

            // case1. 모든(왼쪽) 자식 노드가 없는 경우(완전이진트리는 왼쪽부터 채워지므로)
            if leftChildIndex >= heap.count {
                return .none
            }

            // case2. 왼쪽 자식 노드만 있는 경우
            if rightChildIndex >= heap.count {
                return heap[leftChildIndex] < heap[poppedIndex] ? .left : .none
            }

            // case3. 왼쪽&오른쪽 자식 노드 모두 있는 경우
            // case3-1. 자식들이 자신보다 모두 큰 경우(자신이 제일 작은 경우)
            if (heap[leftChildIndex] > heap[poppedIndex]) && (heap[rightChildIndex] > heap[poppedIndex]) {
                return .none
            }

            // case3-2. 자식들이 자신보다 모두 작은 경우(왼쪽과 오른쪽 자식 중, 더 작은 자식을 선별)
            if (heap[leftChildIndex] < heap[poppedIndex]) && (heap[rightChildIndex] < heap[poppedIndex]) {
                return heap[leftChildIndex] < heap[rightChildIndex] ? .left : .right
            }

            // case3-3. 왼쪽과 오른쪽 자식 중, 한 자식만 자신보다 작은 경우
            if (heap[leftChildIndex] < heap[poppedIndex]) || (heap[rightChildIndex] < heap[poppedIndex]) {
                return heap[leftChildIndex] < heap[rightChildIndex] ? .left : .right
            }

            return .none
        }

        var poppedIndex = 1
        while true {
            switch moveDown(poppedIndex) {
            case .none:
                return returnData
            case .left:
                let leftChildIndex = poppedIndex * 2
                heap.swapAt(poppedIndex, leftChildIndex)
                poppedIndex = leftChildIndex
            case .right:
                let rightChildIndex = (poppedIndex * 2) + 1
                heap.swapAt(poppedIndex, rightChildIndex)
                poppedIndex = rightChildIndex
            }
        }
    }
}


func solution(classes: [Schedule]) -> Int {
    let classes = classes.sorted { $0.start < $1.start }
    var heap: MinHeap<Int> = MinHeap()

    for (start, end) in classes {
        if let fastestEnd = heap.pop(), start < fastestEnd {
            heap.push(fastestEnd)
        }

        heap.push(end)
    }

    return heap.count
}

let N = Int(readLine()!)!
var classes = [Schedule]()

for _ in 0..<N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    classes.append((input[0], input[1]))
}

print(solution(classes: classes))

