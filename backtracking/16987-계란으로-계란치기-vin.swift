let N = Int(readLine()!)!
var eggs: [(s: Int, w: Int)] = []
var brokenEggIndexs: [Int] = []
var maximumBrokenEggCount: Int = 0
var count: Int = 0

for _ in 1...N {
    let input = readLine()!.split(separator: " ").map { Int(String($0))! }
    eggs.append((input[0], input[1]))
}

func puzzle(_ preEggIndex: Int) {
    
    // 앞에 들었던 애가 마지막이면
    if preEggIndex == N - 1 {
        var brokenEggCount = 0
        
        // 깨진 달걀 개수 세기
        for index in 0..<N {
            if eggs[index].s <= 0 { brokenEggCount += 1 }
        }
        maximumBrokenEggCount = max(maximumBrokenEggCount, brokenEggCount)
        return
    }
    
    // 지금 막 든 달걀 번호
    let currentEggIndex = preEggIndex + 1
    
    // 지금 막 든 달걀이 깨졌으면 다음 달걀로 진행
    if eggs[currentEggIndex].s <= 0 {
        puzzle(currentEggIndex)
    } else {
        
        var areAllEggsBroken: Bool = true
        
        // 달걀 하나씩 체크
        for index in 0..<N {
            
            // 깰 달걀 번호가 지금 들고 있는 달걀 번호거나, 깰 달걀이 이미 깨져있으면 다음 번호로 진행
            if index == currentEggIndex || eggs[index].s <= 0 { continue }
            else { areAllEggsBroken = false }
            
            eggs[currentEggIndex].s -= eggs[index].w
            eggs[index].s -= eggs[currentEggIndex].w
            
            puzzle(currentEggIndex)
            
            eggs[currentEggIndex].s += eggs[index].w
            eggs[index].s += eggs[currentEggIndex].w
        }
        
        // 다른 달걀들이 다 깨져서 깰 달걀이 없으면
        if areAllEggsBroken {
            var brokenEggCount = 0
            
            // 깨진 달걀 개수 세기
            for index in 0..<N {
                if eggs[index].s <= 0 { brokenEggCount += 1 }
            }
            maximumBrokenEggCount = max(maximumBrokenEggCount, brokenEggCount)
            return
        }
    }
}

puzzle(-1)

print(maximumBrokenEggCount)
