/*
- https://www.acmicpc.net/problem/4256
*/

import Foundation

func divideAndConquer(preorder: [Int], inorder: [Int]) -> [Int] {
    guard preorder != inorder
    else {
        return preorder.reversed()
    }

    let root = preorder[0], inorderRootIndex = inorder.firstIndex(of: root)!
    let leftInorder = (0..<inorderRootIndex).map { inorder[$0] }
    let rightInorder = (inorderRootIndex + 1..<inorder.endIndex).map { inorder[$0] }

    let rightPreorderStartIndex = leftInorder.count + 1
    let leftPreorder = (1..<rightPreorderStartIndex).map { preorder[$0] }
    let rightPreorder = (rightPreorderStartIndex..<preorder.endIndex).map { preorder[$0] }

    let left = divideAndConquer(preorder: leftPreorder, inorder: leftInorder)
    let right = divideAndConquer(preorder: rightPreorder, inorder: rightInorder)

    return left + right + [root]
}

for _ in 0..<Int(readLine()!)! {
    _ = readLine()!
    let preorder = readLine()!.split(separator: " ").map { Int(String($0))! }
    let inorder = readLine()!.split(separator: " ").map { Int(String($0))! }
    print(divideAndConquer(preorder: preorder, inorder: inorder).map { String($0) }.joined(separator: " "))
}
