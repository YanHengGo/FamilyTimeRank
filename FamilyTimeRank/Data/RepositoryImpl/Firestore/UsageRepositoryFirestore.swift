import Foundation

final class UsageRepositoryFirestore: UsageRepository {
    private let dataSource: FirestoreUsageDataSource
    private let familyId: String
    private let dateFormatter: DateFormatter

    init(
        familyId: String,
        dataSource: FirestoreUsageDataSource,
        dateFormatter: DateFormatter = UsageRepositoryFirestore.makeDateFormatter()
    ) {
        self.familyId = familyId
        self.dataSource = dataSource
        self.dateFormatter = dateFormatter
    }

    func fetchUsage(for date: Date) async throws -> [UsageTime] {
        // TODO: Temporary fixed date for testing until daily data is available.
        // let dateKey = dateFormatter.string(from: date)
        let dateKey = "20260112"
        let devices = try await dataSource.fetchUsageDevices(familyId: familyId, dateKey: dateKey)
        let totals = devices.reduce(into: [String: Int]()) { acc, item in
            acc[item.memberId, default: 0] += item.minutes
        }
        return totals.map { memberId, minutes in
            UsageTime(
                id: "usage-\(memberId)-\(dateKey)",
                memberId: memberId,
                minutes: minutes
            )
        }
    }

    private static func makeDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }
}
