/*
 - https://www.acmicpc.net/problem/19598
 - 그리디
*/

import Foundation

typealias Schedule = (start: Int, end: Int)

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


func solution(classes: [Schedule]) -> Int {
    let classes = classes.sorted { $0.start < $1.start }
    var heap: Heap<Int> = Heap { $0 < $1 }

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

