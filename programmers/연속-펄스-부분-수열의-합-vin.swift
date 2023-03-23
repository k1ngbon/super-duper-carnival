import Foundation

func solution(_ sequence:[Int]) -> Int64 {
    
    let N = sequence.count
    var maxSumArray: [[Int64]] = Array(repeating: Array(repeating: Int64.min, count: 2), count: N)
    var maxValue: Int64 = Int64.min
    
    maxSumArray[0][0] = Int64(sequence[0])
    maxSumArray[0][1] = Int64(sequence[0] * (-1))
    
    for i in 1..<N {
        let multiNum = i % 2 == 0 ? 1 : -1
        let currNum = Int64(sequence[i] * multiNum)
        
        maxSumArray[i][0] = max(maxSumArray[i - 1][0] + currNum, currNum)
        maxSumArray[i][1] = max(maxSumArray[i - 1][1] + currNum * (-1), currNum * (-1))
        
        let currMax = max(maxSumArray[i][0], maxSumArray[i][1])
        
        if currMax > maxValue {
            maxValue = currMax
        }
    }
    
    return N > 1 ? maxValue : maxSumArray[0].max()!
}
