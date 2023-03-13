/*
 - https://www.acmicpc.net/problem/1753
 - 최단거리(다익스트라)
 - 가중치만 다르고 출발 도착은 동일한 중복 간선이 들어올 수 있다고 해서 파싱할 때 딕셔너리를 통해서 중복 간선은 제거했는데
   다른 사람들 시간 걸린 거 보니까 어차피 간선 개수가 그렇게 많지 않아서 오히려 이게 더 시간 오래 걸리는 듯 ㅋㅎ
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


typealias Edge = (node: Int, cost: Int)
let impossible = "INF"

func solution(N: Int, edges: [[Int]], start: Int) -> [Int] {
    let start = start - 1, graph = parseEdges(edges, N: N)
    var distance = Array(repeating: Int.max, count: N)
    var heap = Heap(elements: [Edge(start, 0)]) { $0.cost < $1.cost }

    while let (node, cost) = heap.pop() {
        guard cost < distance[node]
        else {
            continue
        }

        distance[node] = cost
        for (next, nextCost) in graph[node] {
            heap.push((next, cost + nextCost))
        }
    }

    return distance
}

func parseEdges(_ egdes: [[Int]], N: Int) -> [[Edge]] {
    var graph = Array(repeating: [Int: Int](), count: N)
    for edge in egdes {
        let dep = edge[0] - 1, arr = edge[1] - 1, cost = edge[2]
        graph[dep][arr] = min(graph[dep][arr, default: .max], cost)
    }

    return graph.map { dict in dict.keys.map { ($0, dict[$0]!) }}
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }, start = Int(readLine()!)!
var edges = [[Int]]()

for _ in 0..<input[1] {
    edges.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

print(
    solution(N: input[0], edges: edges, start: start)
        .map { $0 == .max ? impossible : $0.description }
        .joined(separator: "\n")
)
