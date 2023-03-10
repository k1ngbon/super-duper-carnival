let N = Int(readLine()!)!
var numbers: [Int] = [0]
var hasVisited: [Bool] = Array(repeating: false, count: N + 1)
var isRightSet: Bool = false
var rightSets: Set<Int> = []

func gatherRightSet(with pivotIndex: Int, _ pivotNumber: Int) {
    if hasVisited[pivotNumber] {
        if pivotIndex == pivotNumber {
            isRightSet = true
            rightSets.insert(pivotNumber)
        }
        return
    }
    
    hasVisited[pivotNumber] = true
    gatherRightSet(with: pivotIndex, numbers[pivotNumber])
    
    if isRightSet {
        rightSets.insert(pivotNumber)
        rightSets.insert(numbers[pivotNumber])
    }
}

for _ in 1...N {
    numbers.append(Int(readLine()!)!)
}

for i in 1...N {
    hasVisited[i] = true
    gatherRightSet(with: i, numbers[i])
    
    isRightSet = false
    for j in 1...N {
        hasVisited[j] = false
    }
}

print(rightSets.count)
for num in rightSets.sorted() {
    print(num)
}

