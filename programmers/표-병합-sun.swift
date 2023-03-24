/*
- https://school.programmers.co.kr/learn/courses/30/lessons/150366/language=swift
- union-find / 구현
- 최초 정답은 [이거]( https://school.programmers.co.kr/learn/courses/30/lessons/150366/solution_groups?language=swift&type=my)였는데 union-find 방식으로 풀었다...
  배열 크기가 작아서 걍 merge, unmerge마다 전체를 업데이트할까 생각도 했으나 그래도 union-find가 더 빠르겠지 싶었는데 걍 전체 갱신으로 가야했음 ㅋㅎ
  처음에 findRoot를 빼먹었는데 이건 금방 고쳐서 ㅇㅋㅇㅋ였음 근데 unmerge할 때 원래는 updateAll()이 따로 없고 걍 반복문에서 확인 후 바로 갱신했는데 
  이러니까 그래프에 루트 관계가 A <- B <- C 처럼 되어 있는 경우 B가 먼저 unmerge 되어 버리면 C는 unmerge 되어야 하는데 안되는 문제가 있었다... 
  이거 찾느라 오래 걸림 즐거워요~~~~~~~~
- 암튼 그래서 풀고 나서 union-find 대신 merge-unmerge 시 업데이트 방식으로 다시 풀었는데(아래 풀이) 시간 차이 거의 없고 구현은 훨씬 쉬웠다....흑흑
- 📣 결론: 냅다 구현하지 말고 뭐가 더 단순한 풀이인지 충분히 따져보고 구현 들어가기...
- 작년에 실전에서 풀었을 때는 operate 메서드를 어떻게 분기할 지 고민하다가 거의 100줄 가까이 썼던 거 같은데 
  >>인자를 받는<< 개별 메서드로 나누면 됐다...ㅋㅎ
- illegal instruction -> index out of range error 일 확률이 높음
- 아니 그리고 진짜 이상한거 graph 초기화할 때 메서드 내부 인덴트가 이상한 게 한 줄 있었는데 그거 때문에 런타임 에러 나서 95점 나옴 대체 무엇?!?!?!?
*/
import Foundation

typealias Coordinate = (r: Int, c: Int)
typealias Info = (value: String?, root: Coordinate)

private let empty = "EMPTY", N = 50
private var graph: [[Info]] = {
    var graph = [[Info]]()

    for row in 0..<N {
        var array = [Info]()
        for col in 0..<N {
            array.append((nil, (row, col)))
        }
        graph.append(array)
    }

    return graph
}()

private var prints = [String]()

private enum Command {
    case update(r: Int, c: Int, value: String)
    case updateAll(oldValue: String, newValue: String)
    case merge(r1: Int, c1: Int, r2: Int, c2: Int)
    case unmerge(r: Int, c: Int)
    case print(r: Int, c: Int)

    func operate() {
        switch self {
        case let .update(r, c, value):
            update(r: r, c: c, value: value)
        case let .updateAll(oldValue, newValue):
            updateAll(oldValue: oldValue, newValue: newValue)
        case let .merge(r1, c1, r2, c2):
            merge(r1: r1, c1: c1, r2: r2, c2: c2)
        case let .unmerge(r, c):
            unmerge(r: r, c: c)
        case let .print(r, c):
            print(r: r, c: c)
        }
    }

    private func update(r: Int, c: Int, value: String) {
        let (r, c) = graph[r][c].root
        graph[r][c].value = value
    }

    private func updateAll(oldValue: String, newValue: String) {
        for r in 0..<N {
            for c in 0..<N {
                guard graph[r][c].value == oldValue
                else {
                    continue
                }

                graph[r][c].value = newValue
            }
        }
    }

    private func merge(r1: Int, c1: Int, r2: Int, c2: Int) {
        let root1 = graph[r1][c1].root, root2 = graph[r2][c2].root
        let value = graph[root1.r][root1.c].value ?? graph[root2.r][root2.c].value
        let newRoot = root1.r < root2.r ? root1 : (root2.r < root1.r ? root2 : (root1.c < root2.c ? root1 : root2))
        let oldRoot = newRoot == root1 ? root2 : root1

        graph[oldRoot.r][oldRoot.c].root = newRoot
        graph[newRoot.r][newRoot.c].value = value

        for r in 0..<N {
            for c in 0..<N {
                guard graph[r][c].root == oldRoot
                else {
                    continue
                }

                graph[r][c].root = newRoot
            }
        }
    }

    private func unmerge(r: Int, c: Int) {
        let root = graph[r][c].root, value = graph[root.r][root.c].value

        for row in 0..<N {
            for col in 0..<N {
                guard graph[row][col].root == root
                else {
                    continue
                }

                graph[row][col] = (nil, (row, col))
            }
        }

        graph[r][c].value = value
    }

    private func print(r: Int, c: Int) {
        let (r, c) = graph[r][c].root
        prints.append(graph[r][c].value ?? empty)
    }
}

func solution(_ commands:[String]) -> [String] {
    let commands = parsedCommands(commands)
    commands.forEach { $0.operate() }

    return prints
}

private func parsedCommands(_ commands: [String]) -> [Command] {
    commands.map { command in
        let data = command.split(separator: " ").map { String($0) }

        if data[0] == "MERGE" {
            return .merge(
                r1: Int(data[1])! - 1, c1: Int(data[2])! - 1,
                r2: Int(data[3])! - 1, c2: Int(data[4])! - 1
            )
        }
        if data[0] == "UNMERGE" {
            return .unmerge(r: Int(data[1])! - 1, c: Int(data[2])! - 1)
        }
        if data[0] == "PRINT" {
            return .print(r: Int(data[1])! - 1, c: Int(data[2])! - 1)
        }
        /// update
        if data.count == 4 {
            return .update(r: Int(data[1])! - 1, c: Int(data[2])! - 1, value: data[3])
        }
        /// update all
        return .updateAll(oldValue: data[1], newValue: data[2])
    }
}

