/*
- https://school.programmers.co.kr/learn/courses/30/lessons/150369
- 구현
- 작년에 실제 시험 때는 자꾸 하나씩 빠트려서 이거에만 거의 1시간 걸렸고 결국 후반부에 시간이 부족해서 고통받았기 때문에...
  이번에는 효율성은 안 따지고 무조건 실수를 최소화하면서 간단하게 풀려고 노력했다.
- 최소 거리를 구하려면 결국 멀리 가는 횟수를 최소화해야하므로 먼 거리부터 cap만큼 최대한 처리해야 한다. 
  그래서 단순하게 가장 먼 집에서부터 택배가 있고 + 자신보다 먼 집을 가는 길에 같이 해결할 수 없는 경우,
  다시 말하면 (가장 먼 집이거나 아니면) 더 먼 집에 가는 회차는 이미 cap이 마감된 경우 여기가 새로운 가장 먼 배달 지점이 되므로
  이를 stop 배열에 저장하고, 배달 stop과 픽업 stop를 동일한 인덱스 값끼리 비교해서 더 큰 값만큼 거리에 더해주는 식으로 풀었다
  (어차피 둘 중에 더 먼 거리를 가면 짧은 거리는 자동으로 가게 되고 결론적으로 먼 거리만큼 왕복하니까...)
  - stop 구하는 parse() 함수가 O(N)이라 비효율적인데 줄이려면 줄일 수 있지만 문제 조건을 봤을 때 시간 초과가 안 날 것 같아서 
    실전이라면 나중에 시간 남으면 개선하러 오는 게 맞는 것 같아서 개선 안했다...^^ 절대 귀찮아서 그런 거 아니고.. 
- 처음에 아래 풀이가 시간초과가 나서 postLast() 대신 인덱스 접근으로 바꿔서 내고 그건 되길래 이거 다시 제출해봤더니 잘만 통과함 대체 무엇...?
*/
import Foundation

func solution(_ cap:Int, _ n:Int, _ deliveries:[Int], _ pickups:[Int]) -> Int64 {
    var deliveryStops = parse(deliveries, cap: cap), pickupStops = parse(pickups, cap: cap)
    var time = 0

    while !deliveryStops.isEmpty || !pickupStops.isEmpty {
        time += max(deliveryStops.popLast() ?? 0, pickupStops.popLast() ?? 0) * 2
    }

    return Int64(time)
}

private func parse(_ boxes: [Int], cap: Int) -> [Int] {
    var boxes = boxes, count = 0, stops = [Int]()

    /// 가장 먼 집부터 돌면서 임의의 회차의 가장 먼 stop인지 확인
    for index in stride(from: boxes.count - 1, through: 0, by: -1) {
        while boxes[index] != 0 {
            /// 택배 개수가 cap으로 나누어 떨어지는 경우 이전 회차는 더 이상 택배 처리가 불가하므로 새로운 회차의 stop이 됨
            if count % cap == 0 {
                stops.append(index + 1)
            }
            count += 1
            boxes[index] -= 1
        }
    }

    /// popLast()를 쓸 수 있도록 뒤집어서 리턴
    return stops.reversed()
}
