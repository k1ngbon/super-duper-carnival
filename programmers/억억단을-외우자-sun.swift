/*
- https://school.programmers.co.kr/learn/courses/30/lessons/138475?language=swift
*/
import Foundation

/// s <= target <= e
func solution(_ e:Int, _ starts:[Int]) -> [Int] {
    var numberOfPrimeFactors = Array(repeating: 0, count: e + 1)
    for factor in 1...e {
        for times in factor...e {
            let number = factor * times
            guard number <= e
            else {
                break
            }

            numberOfPrimeFactors[number] += factor == times ? 1 : 2
        }
    }

    var array = Array(repeating: 0, count: e + 1), maxCount = 0
    for number in stride(from: e, through: 1, by: -1) {
        let count = numberOfPrimeFactors[number]
        if count >= maxCount {
            array[number] = number
            maxCount = count
        } else {
            array[number] = array[number + 1]
        }
    }

    var answer = [Int]()
    for start in starts {
        answer.append(array[start])
    }

    return answer
}