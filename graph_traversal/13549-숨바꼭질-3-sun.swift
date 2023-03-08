/*
 - https://www.acmicpc.net/problem/13549
 - 그래프탐색(우선순위 큐)
 - 예전에 dp로 풀었는데 우선순위큐로도 풀린다 근데 시간 복잡도 어케 알지...?
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

typealias Turn = (time: Int, position: Int)

func solution(N: Int, K: Int) -> Int {
    let lo = 0, hi = 100_000
    var heap: Heap<Turn> = Heap(elements: [(0, N)]) { $0.time < $1.time }
    var visited = Array(repeating: false, count: hi + 1)

    while let (time, position) = heap.pop() {
        guard position != K
        else {
            return time
        }

        guard !visited[position]
        else {
            continue
        }

        visited[position].toggle()

        if position - 1 >= lo {
            heap.push((time + 1, position - 1))
        }
        if position + 1 <= hi {
            heap.push((time + 1, position + 1))
        }
        if 1...hi ~= position * 2 {
            heap.push((time, position * 2))
        }
    }

    return -1
}

let input = readLine()!.split(separator: " ").map { Int(String($0))! }
print(solution(N: input[0], K: input[1]))
