/*
- https://www.acmicpc.net/problem/21939
- 자료구조(우선순위큐)

# 생각과정
- 딱 보고 첨에 이중우선순위큐 문제와 같다고 생각했다
- 그러다가 remove 때문에 다르게 가야되나 했는데 걍 유효하지 않으면 계속 pop하도록 하면 될 것 같았다. 
- 근데...33% 쯤에서 틀림 ㅠ 
- 문제 읽으면서 add 연산에서 "이전에 추천 문제 리스트에 있던 문제 번호가 다른 난이도로 다시 들어 올 수 있다." 이거 보고 
  어 뭔가 주의해야될 것 같은데...하고 주의를 안했는데..^^
  바로 이게 문제였음 단순히 특정 문제가 있는지가 아니라 특정 문제 & level이 있는지 확인해야됐다
  왜냐면 처음에 (100, 2) (200, 2) 이렇게 있다가 (100, 2)가 solve 되어서 pop되고 (100, 3)이 다시 추가됐는데 
  제일 쉬운 문제를 추천해달라고 들어오면 minHeap은 현재 (100, 2), (200, 2), (100, 3) 이렇게 구성되어서 
  (100, 2)는 이미 없는 놈이고, (100, 3)만 유효하다는 것을 검증해 줄 필요가 있었다.... 
  그래서 원래 counter 를 bool 배열으로 선언했는데 Int로 바꿔줬더니 해결~
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

// MARK: - Heap

struct Heap<T> {

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

   @discardableResult
   mutating func pop() -> T? {
       guard !isEmpty else { return nil }

       elements.swapAt(elements.startIndex, elements.endIndex - 1)
       let peek = elements.removeLast()
       shiftDown(from: .zero)

       return peek
   }

    func print() {
        Swift.print(elements.sorted(by: isRightHandSideFirst))
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

// MARK: - Solution

private let hard = 1, easy = -1
private let number = 0, level = 1
private let add = "add", rec = "recommend", sol = "solved"

var problems = [[Int]](), commands = [[String]]()

for _ in 0..<file.readInt() {
    problems.append([file.readInt(), file.readInt()])
}

for _ in 0..<file.readInt() {
    var command = [String]()
    command.append(file.readString())
    command.append(file.readString())

    if command[0] == add {
        command.append(file.readString())
    }

    commands.append(command)
}

print(solution(problems, commands).map { String($0) }.joined(separator: "\n"))


func solution(_ problems: [[Int]], _ commands: [[String]]) -> [Int] {
    var answers = [Int](), counter = Array(repeating: 0, count: 100_001)
    problems.forEach { counter[$0[0]] = $0[1] }
    var minHeap = Heap(problems) { $0[level] != $1[level] ? $0[level] < $1[level] : $0[number] < $1[number] }
    var maxHeap = Heap(problems) { $0[level] != $1[level] ? $0[level] > $1[level] : $0[number] > $1[number] }

    for command in commands {
        let type = command[0], number = Int(command[1])!
        if type == add {
            let level = Int(command[2])!
            minHeap.push([number, level])
            maxHeap.push([number, level])
            counter[number] = level
            continue
        } else if type == sol {
            counter[number] = 0
            continue
        }

        var answer: Int

        if number == hard {
            while counter[maxHeap.peek![0]] != maxHeap.peek![1] {
                maxHeap.pop()
            }
            answer = maxHeap.peek![0]
        } else {
            while counter[minHeap.peek![0]] != minHeap.peek![1] {
                minHeap.pop()
            }
            answer = minHeap.peek![0]
        }

        answers.append(answer)
    }

    return answers
}
