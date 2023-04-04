/*
- https://school.programmers.co.kr/learn/courses/30/lessons/67259
- 다익스트라(근데 그냥 dfs도 되는 듯?!)

생각 과정
- bfs/dfs해서 가지치...? 최대한 직전 방향으로만 가는 건 안되고...
- visited에 해당 칸까지의 최소 비용을 갱신하는 방법으로 다익스트라!
- 아 근데 코너 판단 때메 방향을 기록해야됨...근데 그러면 생각해보니까 현재 칸에 도착한 방향이 비용 계산에 영향을 주겠네
  최소 비용으로 가려면 현재 칸에서 반드시 다음에 오른쪽으로 가야된다고 가정하면 
  현재 칸에도 오른쪽에서 도착한 경우가 다른 방향보다 비싸더라도 차이가 코너 비용 미만이면 이게 최적이다... 
- 그럼 visited를 2차원이 아니라 3차원으로 해서 해당 방향으로 방문한 적이 있는지 확인해야될듯
- 시작점도 방향 때문에 잘 따져서 넣어야 됨
*/

import Foundation

typealias Status = (row: Int, col: Int, cost: Int, dir: Int)
private let empty = 0, wall = 1, roadCost = 100, cornerCost = 500

func solution(_ board:[[Int]]) -> Int {
    let N = board.count, directions = [(1, 0), (-1, 0), (0, 1), (0, -1)].enumerated()
    var visited = paddedBoard(board)
    visited[1][1] = [1, 1, 1, 1]
    var heap: Heap<Status> = Heap(elements: [(2, 1, roadCost, 0), (1, 2, roadCost, 2)]) { $0.cost < $1.cost }

    while let (row, col, cost, dir) = heap.pop() {
        guard visited[row][col][dir] == empty
        else {
            continue
        }

        visited[row][col][dir] = cost

        guard (row, col) != (N, N)
        else {
            break
        }

        for (index, (dr, dc)) in directions {
            let nr = row + dr, nc = col + dc
            let newCost = cost + roadCost + (dir == index ? 0 : cornerCost)
            heap.push((nr, nc, newCost, index))
        }

    }

    return visited[N][N].max()!
}

private func paddedBoard(_ board: [[Int]]) -> [[[Int]]] {
    let N = board.count
    let emptys = Array(repeating: empty, count: 4), walls = Array(repeating: wall, count: 4)
    let top = [Array(repeating: walls, count: N + 2)]
    let mid = board.map { row in
        [walls] + row.map { $0 == empty ? emptys : walls } + [walls]
    }
    return top + mid + top
}

private struct Heap<T> {

   // MARK: - Properties

   var count: Int { elements.count }
   var isEmpty: Bool { elements.isEmpty }
   var peek: T? { elements.first }

   private var elements = [T]()
   private var isRightHandSideFirst: (T, T) -> Bool


   // MARK: - Init(s)

   init(elements: [T] = [], orderCriteria: @escaping (T, T) -> Bool) {
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
       let leftChildIndex = leftChildIdx(of: index), rightChildIndex = rightChildIdx(of: index)
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

   private func leftChildIdx(of index: Int) -> Int {
       2 * index + 1
   }

   private func rightChildIdx(of index: Int) -> Int {
       2 * index + 2
   }
}
