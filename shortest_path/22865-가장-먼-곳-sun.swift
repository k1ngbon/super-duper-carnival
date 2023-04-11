/*
- https://www.acmicpc.net/problem/22865
- 시간초과 포기 로직 보니까 맞는데 절대 통과 못시키겠음 
*/

import Foundation

typealias Info = (node: Int, dist: Int)
private func solution(_ N: Int, _ edges: [[Int]], _ friends: [Int]) -> Int {
    let edges = parsedEdges(edges, N: N)
    var house = Array(repeating: Int.max, count: N + 1)

    for friend in friends {
        var heap = Heap([Info(friend, 0)]) { $0.dist < $1.dist }
        var visited = Array(repeating: false, count: N + 1)

        while let (node, dist) = heap.pop() {
            guard !visited[node]
            else {
                continue
            }

            visited[node].toggle()
            house[node] = min(house[node], dist)
            for next in edges[node] {
                if !visited[next.node] {
                    heap.push((next.node, dist + next.dist))
                }
            }
        }
    }

    var (answer, dist) = (-1, -1)

    for index in 1..<house.count {
        let nowDist = house[index]
        if nowDist > dist { 
            answer = index
            dist = nowDist
        }
    }

    return answer
}

private func parsedEdges(_ edges: [[Int]], N: Int) -> [[Info]] {
    var result = Array(repeating: [Info](), count: N + 1)
    for edge in edges {
        let start = edge[0], end = edge[1], dist = edge[2]
        result[start].append((end, dist))
        result[end].append((start, dist))
    }

    return result
}

let N = Int(readLine()!)!
let friends = readLine()!.split(separator: " ").map { Int(String($0))! }
var edges = [[Int]]()

for _ in 0..<Int(readLine()!)! {
    edges.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(N, edges, friends))


private struct Heap<T> {

   // MARK: - Properties

   var count: Int { elements.count }
   var isEmpty: Bool { elements.isEmpty }
   var peek: T? { elements.first }

   private var elements = [T]()
   private var isRightHandSideFirst: (T, T) -> Bool


   // MARK: - Init(s)

   init(_ elements: [T] = [], orderCriteria: @escaping (T, T) -> Bool) {
       self.isRightHandSideFirst = orderCriteria
       self.heapify(elements)
   }


   // MARK: - Methods

   mutating func push(_ element: T) {
       elements.append(element)
       shiftUp(from: elements.endIndex - 1)
   }

   mutating func push(_ elements: [T]) {
       for element in elements {
           push(element)
       }
   }

   mutating func pop() -> T? {
       guard !isEmpty else { return nil }

       elements.swapAt(elements.startIndex, elements.endIndex - 1)
       let peek = elements.removeLast()
       shiftDown(from: .zero)

       return peek
   }

   private mutating func heapify(_ elements: [T]) {
       self.elements = elements
       for index in stride(from: elements.endIndex / 2 - 1, through: 0, by: -1) {
           shiftDown(from: index)
       }
   }

   private mutating func shiftUp(from index: Int) {
       var childIndex = index, parentIndex = self.parentIndex(of: childIndex)
       let child = elements[childIndex]

       while childIndex > .zero,
             isRightHandSideFirst(child, elements[parentIndex]) {

           elements.swapAt(childIndex, parentIndex)
           childIndex = parentIndex
           parentIndex = self.parentIndex(of: childIndex)
       }
   }

   private mutating func shiftDown(from index: Int) {
       let leftChildIndex = leftChildIndex(of: index), rightChildIndex = rightChildIndex(of: index)
       let endIndex = elements.endIndex
       var parentIndex = index

       if leftChildIndex < endIndex, isRightHandSideFirst(elements[leftChildIndex], elements[parentIndex]) {
           parentIndex = leftChildIndex
       }

       if rightChildIndex < endIndex, isRightHandSideFirst(elements[rightChildIndex], elements[parentIndex]) {
           parentIndex = rightChildIndex
       }

       if parentIndex == index { return }

       elements.swapAt(index, parentIndex)
       shiftDown(from: parentIndex)
   }

   private func parentIndex(of index: Int) -> Int {
       (index - 1) / 2
   }

   private func leftChildIndex(of index: Int) -> Int {
       2 * index + 1
   }

   private func rightChildIndex(of index: Int) -> Int {
       2 * index + 2
   }
}
