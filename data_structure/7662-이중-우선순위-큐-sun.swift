/*
- https://www.acmicpc.net/problem/7662
- 자료구조(우선순위 큐)

생각과정
- 이름에서부터 우선순위 큐를 최소, 최대 각각 두고 동기화를 하면 된다고 생각했는데 그냥 pop 하다가
  서로의 peek이 겹치거나 교차하는 경우에 힙을 비워주는 식으로 하면 될 것 같았다 
- 근데 별의 별 예외처리를 해도 안됐음 이떄 빨리 포기했어야 됐는데 ㅋㅎ 
- 결국 솔루션을 봤는데 우선순위 큐만으로는 안되고 딕셔너리를 추가로 사용해야 된다고 되어 있었따 
  그래서 개수를 세는 딕셔너리를 하나 선언해서 push, pop할 때마다 개수를 세고 이걸 사용해서 유효성을 검사하도록 했다
  무슨 multiset? 을 활용하는 것도 방법이라는 데 몰라서 패스...
*/

import Foundation

// MARK: - FileIO

struct FileIO {
    private let buffer:[UInt8]
    private var index: Int = 0

    init(fileHandle: FileHandle = FileHandle.standardInput) {

        buffer = Array(try! fileHandle.readToEnd()!)+[UInt8(0)] // 인덱스 범위 넘어가는 것 방지
    }

    @inline(__always) private mutating func read() -> UInt8 {
        defer { index += 1 }

        return buffer[index]
    }

    @inline(__always) mutating func readInt() -> Int {
        var sum = 0
        var now = read()
        var isPositive = true

        while now == 10
                || now == 32 { now = read() } // 공백과 줄바꿈 무시
        if now == 45 { isPositive.toggle(); now = read() } // 음수 처리
        while now >= 48, now <= 57 {
            sum = sum * 10 + Int(now-48)
            now = read()
        }

        return sum * (isPositive ? 1:-1)
    }

    mutating func readIntArray(_ K: Int) -> [Int] {
        var array = [Int]()

        for _ in 0..<K {
            array.append(readInt())
        }

        return array
    }

    @inline(__always) mutating func readString() -> String {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return String(bytes: Array(buffer[beginIndex..<(index-1)]), encoding: .ascii)!
    }

    mutating func readStringArray(_ K: Int) -> [String] {
        var array = [String]()

        for _ in 0..<K {
            array.append(readString())
        }

        return array
    }

    @inline(__always) mutating func readByteSequenceWithoutSpaceAndLineFeed() -> [UInt8] {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return Array(buffer[beginIndex..<(index-1)])
    }
}

var file = FileIO()


// MARK: - Solution

struct Heap<T> {

   // MARK: - Properties

   var count: Int { elements.count }
   var isEmpty: Bool { elements.isEmpty }
   var peek: T? { elements.first }

   private(set) var elements = [T]()
   private var isRightHandSideFirst: (T, T) -> Bool


   // MARK: - Init(s)

   init(_ elements: [T] = [], _ orderCriteria: @escaping (T, T) -> Bool) {
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

   @discardableResult
   mutating func pop() -> T? {
       guard !isEmpty else { return nil }

       elements.swapAt(elements.startIndex, elements.endIndex - 1)
       let peek = elements.removeLast()
       shiftDown(from: .zero)

       return peek
   }

   mutating func removeAll() {
        elements.removeAll()
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


typealias Operation = (type: String, value: Int)
typealias IntHeap = Heap<Int>
private let delete = "D", insert = "I", mini = -1, maxi = 1

for _ in 0..<file.readInt() {
    var operations = [Operation]()
    for _ in 0..<file.readInt() {
        operations.append((file.readString(), file.readInt()))
    }

    let result = solution(operations)
    print(result.isEmpty ? "EMPTY" : result.map { String($0) }.joined(separator: " "))
}


func solution(_ operations: [Operation]) -> [Int] {
    var minHeap = Heap([Int](), <), maxHeap = Heap([Int](), >)
    var dict = [Int: Int]()

    func printer() {
        print(minHeap.elements.sorted())
        print(maxHeap.elements.sorted())
        print("")
    }

    func popIfNecessary(_ heap: inout IntHeap) {
        while let peek = heap.peek, dict[peek, default: 0] == 0 {
            heap.pop()
        }

        dict[heap.pop() ?? .max, default: 0] -= 1
    }

    for (type, value) in operations {
        guard type == delete
        else {
            minHeap.push(value)
            maxHeap.push(value)
            dict[value, default: 0] += 1
            continue
        }

        if value == mini {
            popIfNecessary(&minHeap)
        } else {
            popIfNecessary(&maxHeap)
        }
    }

    let result = dict.keys.filter { dict[$0, default: 0] > 0 }.sorted()
    return result.isEmpty ? [] : [result.last!, result.first!]
}
