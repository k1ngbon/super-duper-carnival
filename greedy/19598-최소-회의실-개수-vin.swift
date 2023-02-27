struct Heap<Element> {
    var elements : [Element]
    let priorityFunction : (Element, Element) -> Bool
    
    var isEmpty : Bool {
        return elements.isEmpty
    }
    
    var count : Int {
        return elements.count
    }
    
    var peek: Element? {
        return elements.first
    }
    
    init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) {
      self.elements = elements
      self.priorityFunction = priorityFunction
      buildHeap()
    }

    mutating private func buildHeap() {
      for index in (0 ..< count / 2).reversed() {
        shiftDown(elementAtIndex: index)
      }
    }
    
    func isRoot(_ index: Int) -> Bool {
        return (index == 0)
    }
    
    func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }
    
    func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }
    
    func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
    
    func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    
    func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex)
        else { return parentIndex }
        return childIndex
    }
    
    func highestPriorityIndex(for parent: Int) -> Int {
        return highestPriorityIndex(
            of: highestPriorityIndex(
                of: parent,
                and: leftChildIndex(of: parent)
            ),
            and: rightChildIndex(of: parent)
        )
    }
    
    mutating private func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex
        else { return }
        elements.swapAt(firstIndex, secondIndex)
    }
    
    mutating func insert(_ element: Element) {
        elements.append(element)
        shiftUp(elementAtIndex: count - 1)
    }
    
    mutating private func shiftUp(elementAtIndex index: Int) {
        let parent = parentIndex(of: index)
        guard !isRoot(index),
              isHigherPriority(at: index, than: parent)
        else { return }
        swapElement(at: index, with: parent)
        shiftUp(elementAtIndex: parent)
    }
    
    mutating func remove() -> Element? {
        guard !isEmpty
        else { return nil }
        swapElement(at: 0, with: count - 1)
        let element = elements.removeLast()
        if !isEmpty {
            shiftDown(elementAtIndex: 0)
        }
        return element
    }
    
    mutating private func shiftDown(elementAtIndex index: Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex {
            return
        }
        swapElement(at: index, with: childIndex)
        shiftDown(elementAtIndex: childIndex)
    }
}

typealias MeetingRoom = (start: Int, end: Int)

let N = Int(readLine()!)!
var meetings: [MeetingRoom] = []
var heap: Heap<MeetingRoom> = Heap { t1, t2 in
    if t1.end == t2.end { return t1.start < t2.start }
    return t1.end < t2.end
}

for _ in 1...N {
    let time = readLine()!.split(separator: " ").map { Int(String($0))! }
    meetings.append((time[0], time[1]))
}

meetings.sort { $0.start < $1.start }
heap.insert(meetings.removeFirst())

for i in 0..<N - 1 {
    let currentMeeting = meetings[i]
    let lastMeeting = heap.peek!
    
    if currentMeeting.start >= lastMeeting.end {
        heap.remove()
    }
    heap.insert(currentMeeting)
}

print(heap.count)
