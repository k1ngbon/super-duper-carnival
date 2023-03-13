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

let firstInput = readLine()!.split(separator: " ").map{ Int(String($0))! }
let (V, E) = (firstInput[0], firstInput[1])
let K = Int(readLine()!)!
var path: [[(v: Int, w: Int)]] = Array(repeating: [], count: V + 1)
var queue: Heap<(v: Int, w: Int)> = Heap { $0.w < $1.w }
var distance: [Int] = Array(repeating: Int.max, count: V + 1)

for _ in 1...E {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    let (u, v, w) = (input[0], input[1], input[2])
    path[u] += [(v: v, w: w)]
}

queue.insert((v: K, w: 0))
distance[K] = 0

while !queue.isEmpty {
    guard let currNode = queue.remove()
    else { fatalError() }
    
    if distance[currNode.v] < currNode.w { continue }
    
    for i in 0..<path[currNode.v].count {
        let nextNode = path[currNode.v][i]
        
        if distance[nextNode.v] > currNode.w + nextNode.w {
            distance[nextNode.v] = currNode.w + nextNode.w
            queue.insert((v: nextNode.v, w: distance[nextNode.v]))
        }
    }
}

for i in 0..<distance.count {
    if i == 0 { continue }
    if distance[i] == Int.max {
        print("INF")
    } else {
        print(distance[i])
    }
}

