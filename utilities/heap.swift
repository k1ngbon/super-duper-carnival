// MARK: - Heap

struct Heap<T> {

    // MARK: - Properties

    var count: Int { array.count }
    var isEmpty: Bool { array.isEmpty }
    var peek: T? { array.first }
    var elements: [T] { array.sorted(by:isRightHandSideFirst) }


    private var array = [T]()
    private var isRightHandSideFirst: (T, T) -> Bool


    // MARK: - Init(s)

    init(_ elements: [T] = [], orderCriteria: @escaping (T, T) -> Bool) {
        self.isRightHandSideFirst = orderCriteria
        self.heapify(elements)
    }


    // MARK: - Methods

    mutating func push(_ element: T) {
        array.append(element)
        shiftUp(from: array.endIndex - 1)
    }

    mutating func push(_ elements: [T]) {
        for element in elements {
            push(element)
        }
    }

    @discardableResult
    mutating func pop() -> T? {
        guard !isEmpty else { return nil }

        array.swapAt(array.startIndex, array.endIndex - 1)
        let peek = array.removeLast()
        shiftDown(from: .zero)

        return peek
    }

    func print() {
        Swift.print(elements)
    }

    private mutating func heapify(_ elements: [T]) {
        self.array = elements
        for index in stride(from: elements.endIndex / 2 - 1, through: 0, by: -1) {
            shiftDown(from: index)
        }
    }

    private mutating func shiftUp(from index: Int) {
        var childIndex = index, parentIndex = self.parentIndex(of: childIndex)
        let child = array[childIndex]

        while childIndex > .zero,
              isRightHandSideFirst(child, array[parentIndex]) {

            array.swapAt(childIndex, parentIndex)
            childIndex = parentIndex
            parentIndex = self.parentIndex(of: childIndex)
        }
    }

    private mutating func shiftDown(from index: Int) {
        let leftChildIndex = leftChildIndex(of: index), rightChildIndex = rightChildIndex(of: index)
        let endIndex = array.endIndex
        var parentIndex = index

        if leftChildIndex < endIndex, isRightHandSideFirst(array[leftChildIndex], array[parentIndex]) {
            parentIndex = leftChildIndex
        }

        if rightChildIndex < endIndex, isRightHandSideFirst(array[rightChildIndex], array[parentIndex]) {
            parentIndex = rightChildIndex
        }

        if parentIndex == index { return }

        array.swapAt(index, parentIndex)
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
