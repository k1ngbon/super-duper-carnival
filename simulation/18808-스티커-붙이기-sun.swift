/*
- https://www.acmicpc.net/problem/18801
- 구현

# 생각과정
- 보드 크기도 작고 스티커 개수도 작아서 걍 스티커마다 보드 시작부터 끝까지 각 좌표를 시작점으로 스티커를 붙일 수 있는지 완탐으로 확인
  해당 방향에서 불가하면 회전해서 다시 위 과정 반복
- 각 좌표마다 확인은 어떤식으로 할까 하다가 스티커의 좌표를 파싱해서 시작점에서 해당 좌표값만큼 더하면 실제 노트북에서의 위치가 되므로 
  이를 활용해서 확인했다...
- 회전을 어떻게 시켜야될까 고민했는데 공간 제약이 따로 있는 게 아니라서 좀 무식하지만
  그냥 빈 그래프 하나 선언해서 행 단위로 옮겨붙이는 식으로 간단하게 해결~~~ 
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

    @inline(__always) @discardableResult mutating func readInt() -> Int {
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

    @discardableResult mutating func readIntArray(_ K: Int) -> [Int] {
        var array = [Int]()

        for _ in 0..<K {
            array.append(readInt())
        }

        return array
    }

    @inline(__always) @discardableResult mutating func readString() -> String {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return String(bytes: Array(buffer[beginIndex..<(index-1)]), encoding: .ascii)!
    }

    @discardableResult mutating func readStringArray(_ K: Int) -> [String] {
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


typealias Sticker = [[Int]]
typealias Laptop = [[Int]]
typealias Coordinate = (r: Int, c: Int)


let N = file.readInt(), M = file.readInt(), K = file.readInt()
var stickers = [Sticker]()

for _ in 0..<K {
    var sticker = Sticker()
    let R = file.readInt(), C = file.readInt()

    for _ in 0..<R {
        sticker.append(file.readIntArray(C))
    }

    stickers.append(sticker)
}

print(solution(N, M, stickers))


// MARK: - Solution

func solution(_ N: Int, _ M: Int, _ stickers: [Sticker]) -> Int {
    var laptop = Array(repeating: Array(repeating: 0, count: M), count: N)

    for sticker in stickers {
        placeStickerIfPossible(sticker, laptop: &laptop)
    }

    return laptop.reduce(0) { $0 + $1.filter { $0 == 1 }.count }
}

private func placeStickerIfPossible(_ sticker: Sticker, laptop: inout Laptop) {
    var sticker = sticker, coordinates = parseSticker(sticker)
    let empty = 0, full = 1

    func isPlaceable(row: Int, col: Int) -> Bool {
        for (dr, dc) in coordinates {
            guard laptop[safe: row + dr]?[safe: col + dc] == empty
            else {
                return false
            }
        }

        return true
    }

    for _ in 0..<4 {
        for row in 0..<laptop.count {
            for col in 0..<laptop[0].count {
                guard isPlaceable(row: row, col: col)
                else {
                    continue
                }

                coordinates.forEach { laptop[row + $0.r][col + $0.c] = full }
                return
            }
        }

        sticker = rotated(sticker)
        coordinates = parseSticker(sticker)
    }
}

private func parseSticker(_ sticker: Sticker) -> [Coordinate] {
    var coordinates = [Coordinate]()

    for row in 0..<sticker.count {
        for col in 0..<sticker[0].count {
            if sticker[row][col] == 1 {
                coordinates.append((row, col))
            }
        }
    }

    return coordinates
}

private func rotated(_ sticker: Sticker) -> Sticker {
    var graph = Array(repeating: Array(repeating: 0, count: sticker.count), count: sticker[0].count)

    for row in 0..<sticker.count {
        for col in 0..<sticker[0].count {
            let newCol = sticker.count - row - 1
            graph[col][newCol] = sticker[row][col]
        }
    }

    return graph
}

extension Array {

    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
