import Foundation

struct TodayRankingResult: Equatable {
    let ranking: Ranking
    let familyAverageMinutes: Int
}

protocol GetTodayRankingUseCase {
    func execute(for date: Date) -> TodayRankingResult
}

final class GetTodayRankingUseCaseImpl: GetTodayRankingUseCase {
    private let familyRepository: FamilyRepository
    private let usageRepository: UsageRepository

    init(familyRepository: FamilyRepository, usageRepository: UsageRepository) {
        self.familyRepository = familyRepository
        self.usageRepository = usageRepository
    }

    func execute(for date: Date) -> TodayRankingResult {
        let family = familyRepository.fetchFamily()
        let usageList = usageRepository.fetchUsage(for: date)
        let usageByMemberId = Dictionary(uniqueKeysWithValues: usageList.map { ($0.memberId, $0.minutes) })

        let entries = family.members
            .map { member in
                let minutes = usageByMemberId[member.id] ?? 0
                return (member: member, minutes: minutes)
            }
            .sorted {
                if $0.minutes != $1.minutes {
                    return $0.minutes > $1.minutes
                }
                return $0.member.displayName < $1.member.displayName
            }
            .enumerated()
            .map { index, item in
                RankingEntry(
                    id: "ranking-\(item.member.id)",
                    member: item.member,
                    minutes: item.minutes,
                    rank: index + 1
                )
            }

        let totalMinutes = entries.reduce(0) { $0 + $1.minutes }
        let averageMinutes = entries.isEmpty ? 0 : totalMinutes / entries.count

        return TodayRankingResult(
            ranking: Ranking(date: date, entries: entries),
            familyAverageMinutes: averageMinutes
        )
    }
}
