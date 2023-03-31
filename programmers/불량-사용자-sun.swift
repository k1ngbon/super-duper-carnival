/*
- https://school.programmers.co.kr/learn/courses/30/lessons/64064
- 구현, dfs
- 숫자가 다 8인걸 보고 경우의 수가 크지 않을 것 같아서 첨에 왼탐할까 하다가 괜히 매칭 로직 짜보겠다고 설쳤는데 결국 안됐음ㅋㅎ
  바로 완탐 떄렸으면 훨씬 시간 절약했을 듯...ㅎ 
*/
import Foundation

func solution(_ user_id:[String], _ banned_id:[String]) -> Int {
    let matchingIDs = findMatchingIDs(in: user_id, bannedIDs: banned_id)
    let count = calculateAllCases(using: matchingIDs)
    
    return count
}

private func calculateAllCases(using matchingIDs: [[String]]) -> Int {
    var cases = Set<Set<String>>()
    
    func dfs(ids: Set<String>, index: Int) {
        guard index != matchingIDs.endIndex
        else {
            if ids.count == matchingIDs.count {
                cases.insert(ids)
            }
            return
        }
        
        var ids = ids
        for id in matchingIDs[index] {
            if !ids.contains(id) {
                ids.insert(id)
                dfs(ids: ids, index: index + 1)
                ids.remove(id)
            }
        }
    }
    
    dfs(ids: [], index: 0)
    return cases.count
}

private func findMatchingIDs(in userIDs: [String], bannedIDs: [String]) -> [[String]] {
    let star: Character = "*"
    var matchingIDs = [[String]]()
    
    for bannedID in bannedIDs {
        var matches = [String]()
        let count = bannedID.count
        
        outerLoop: for userID in userIDs {
            guard userID.count == count
            else {
                continue
            }
            
            for (c1, c2) in zip(bannedID, userID) {
                if c1 != star, c1 != c2 {
                    continue outerLoop
                }
            }
            
            matches.append(userID)
        }
        
        matchingIDs.append(matches)
    }
    
    return matchingIDs
}

