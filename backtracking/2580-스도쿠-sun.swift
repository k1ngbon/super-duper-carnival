/*
- https://www.acmicpc.net/problem/2580
- 백트래킹

생각과정
- dfs로 하면 되겠다고 생각했는데 시간 초과~
- 비어있는 칸만 순회하도록 변경했는데 그래도 시간 초과... 
- 결국 답을 봤더니 핵심은 가능한 칸을 고르는 findAllCandidates 메서드를 O(1)로 줄이는 것... 
- graph[index][number]의 2차원 배열로 index번째 열/행/박스에 number가 있는지 없는지를 bool로 표시하면 
  특정 칸에 숫자 x를 넣을 수 있는지를 O(1)로 확인 가능하다~~~~

기타
- 약간..graph에 저장할 수 있는 값을 생각하는 걸 잘 못하는듯...?
*/

import Foundation

private let empty = 0
private let boxIndex: (Int, Int) -> Int = { ($0 / 3 * 3) + ($1 / 3) }

private func solution(_ sudoku: [[Int]]) -> [[Int]] {
    let empties = (0..<9).flatMap { row in (0..<9).compactMap { sudoku[row][$0] == empty ? (row, $0) : nil} }
    var sudoku = sudoku, (rows, cols, box) = parse(sudoku)

    @discardableResult
    func dfs(index: Int) -> Bool {
        if index == empties.endIndex {
            return true
        }

        let (row, col) = empties[index], bIndex = boxIndex(row, col)
        for number in findAllCandidates(row: row, col: col) {
            sudoku[row][col] = number
            rows[row][number] = true
            cols[col][number] = true
            box[bIndex][number] = true
            if dfs(index: index + 1) { 
                return true
            }
            rows[row][number] = false
            cols[col][number] = false
            box[bIndex][number] = false
        }
        
        sudoku[row][col] = empty
        return false
    }

    func findAllCandidates(row: Int, col: Int) -> [Int] {
        let bIndex = boxIndex(row, col)
        return (1...9).filter { !rows[row][$0] && !cols[col][$0] && !box[bIndex][$0] }
    }
    
    if !empties.isEmpty {
        dfs(index: 0)
    }

    return sudoku
}

private func parse(_ sudoku: [[Int]]) -> ([[Bool]], [[Bool]], [[Bool]]) {
    let count = sudoku.count
    var rows = Array(repeating: Array(repeating: false, count: count + 1), count: count)
    var cols = rows
    var box = rows

    for r in 0..<count {
        for c in 0..<count {
            let number = sudoku[r][c]
            guard number != empty
            else {
                continue
            }

            rows[r][number] = true
            cols[c][number] = true
            box[boxIndex(r, c)][number] = true
        }
    }

    return (rows, cols, box)
}

var sudoku = [[Int]]()

for _ in 0..<9 {
    sudoku.append(readLine()!.split(separator: " ").map { Int(String($0))! })
}

solution(sudoku).forEach { print($0.map { String($0) }.joined(separator: " ")) }
