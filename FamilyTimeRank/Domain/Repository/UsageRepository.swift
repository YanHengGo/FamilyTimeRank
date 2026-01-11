import Foundation

protocol UsageRepository {
    func fetchUsage(for date: Date) -> [UsageTime]
}
