import Foundation

final class UsageRepositoryFake: UsageRepository {
    func fetchUsage(for date: Date) -> [UsageTime] {
        return [
            UsageTime(id: "usage-dad", memberId: "member-dad", minutes: 200),
            UsageTime(id: "usage-mom", memberId: "member-mom", minutes: 105),
            UsageTime(id: "usage-son", memberId: "member-son", minutes: 160),
            UsageTime(id: "usage-daughter", memberId: "member-daughter", minutes: 50)
        ]
    }
}
