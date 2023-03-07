let C = Int(readLine()!)!
var potentials: [[Int]] = []
var pSums: [Int] = []
var hasSelected: [Bool] = Array(repeating: false, count: 11)

for _ in 1...C {
    
    potentials = []
    pSums = []
    hasSelected = Array(repeating: false, count: 11)
    
    for _ in 1...11 {
        let p = readLine()!.split(separator: " ").map { Int(String($0))! }
        potentials.append(p)
    }

    makePosition(with: 0, 0)
    print(pSums.max() == nil ? 0 : pSums.max()!)
}

func makePosition(with positionIdx: Int, _ sum: Int) {
    if positionIdx == 11 {
        if hasSelected.allSatisfy({ $0 == true }) {
            pSums.append(sum)
        }
        return
    }
    
    for (num, potential) in potentials.enumerated() {
        
        // num 선수가 선발되지 않았고, 해당 포지션에 능력치가 있으면
        if !hasSelected[num] && potential[positionIdx] != 0 {
            hasSelected[num] = true
            makePosition(with: positionIdx + 1, sum + potential[positionIdx])
            hasSelected[num] = false
        }
    }
}
