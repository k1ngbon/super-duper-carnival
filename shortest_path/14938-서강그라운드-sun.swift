/*
 - https://www.acmicpc.net/problem/14938
 - 그래프탐색(다익스트라)
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

typealias Edge = (node: Int, distance: Int)

func solution(edges: [[Int]], items: [Int], maxDistance: Int) -> Int {
    let graph = parseEdges(edges, N: items.count)
    var maxItems = 0

    for start in 0..<items.count {
        var heap = Heap(elements: [Edge(start, 0)]) { $0.distance < $1.distance }
        var visited = Array(repeating: false, count: items.count)
        var itemCount = 0

        while let (node, distance) = heap.pop() {
            guard !visited[node],
                  distance <= maxDistance
            else {
                continue
            }

            visited[node].toggle()
            itemCount += items[node]
            for next in graph[node] {
                heap.push((next.node, next.distance + distance))
            }
        }

        maxItems = max(maxItems, itemCount)
    }

    return maxItems
}

func parseEdges(_ edges: [[Int]], N: Int) -> [[Edge]] {
    var graph = Array(repeating: [Edge](), count: N)

    for edge in edges {
        let a = edge[0] - 1, b = edge[1] - 1, distance = edge[2]
        graph[a].append(Edge(b, distance))
        graph[b].append(Edge(a, distance))
    }

    return graph
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
let N = input[0], maxDistance = input[1], R = input[2]
let items = readLine()!.split(separator: " ").map { Int(String($0))! }
var edges = [[Int]]()

for _ in 0..<R {
    edges.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(solution(edges: edges, items: items, maxDistance: maxDistance))
