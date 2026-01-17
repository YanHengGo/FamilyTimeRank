import Foundation

protocol UsageRepository {
    func fetchUsage(for date: Date) async throws -> [UsageTime]
}
