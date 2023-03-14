/*
 - https://www.acmicpc.net/problem/1277
 - 그래프탐색(다익스트라)
 - 처음에 잘못해서 경우의 수가 너무 많은 거 아닌가 했는데 새로운 전깃줄을 추가하는 문제니까
   걍 다른 모든 발전소에 대해서 최단거리를 따져서 그 중에 제한 거리보다 짧은 경우에만 우선순위큐에 넣어주면 되는 문제!
   이때 최단거리를 따질 때는 대각선도 된다는 점에 주의하면 된다!
 */

import Foundation

struct Heap<T> {

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

// 최소의 길이를 추가해서 발전소를 연결
// 다른 발전소 거치기 가능
// 두 발전소 사이의 길이가 M 초과 불가능

typealias Coordinate = (x: Int, y: Int)
typealias Edge = (index: Int, distance: Double)

func solution(graph: [[Int]], positions: [Coordinate], limit: Double) -> Int {
    let destination = positions.count - 1, graph = parseGraph(graph, N: positions.count)
    var heap = Heap(elements: [Edge(0, 0)]) { $0.distance < $1.distance }
    var visited = Array(repeating: false, count: positions.count)

    while let (index, distance) = heap.pop() {
        guard !visited[index]
        else {
            continue
        }

        if index == destination {
            return Int(distance * 1000)
        }

        visited[index].toggle()
        let (x, y) = positions[index]

        for (nextIndex, (nx, ny)) in positions.enumerated() {
            guard nextIndex != index
            else {
                continue
            }

            let minDistance = (pow(Double(x - nx), 2) + pow(Double(y - ny), 2)).squareRoot()
            if graph[index].contains(nextIndex) {
                heap.push((nextIndex, distance))
            } else if minDistance <= limit {
                heap.push((nextIndex, distance + minDistance))
            }
        }
    }

    return -1
}

func parseGraph(_ edges: [[Int]], N: Int) -> [Set<Int>] {
    var graph = Array(repeating: Set<Int>(), count: N)
    for edge in edges {
        let a = edge[0] - 1, b = edge[1] - 1
        graph[a].insert(b)
        graph[b].insert(a)
    }

    return graph
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let N = input[0], W = input[1], limit = Double(readLine()!)!
var positions = [Coordinate](), edges = [[Int]]()

for _ in 0..<N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    positions.append((input[0], input[1]))
}
for _ in 0..<W {
    edges.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(graph: edges, positions: positions, limit: limit))
