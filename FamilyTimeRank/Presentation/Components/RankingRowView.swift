import SwiftUI

struct RankingRowView: View {
    let rank: Int
    let displayName: String
    let minutes: Int
    private var timeText: String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        if hours > 0 && remainingMinutes > 0 {
            return "\(hours)時間\(remainingMinutes)分"
        }
        if hours > 0 {
            return "\(hours)時間"
        }
        return "\(remainingMinutes)分"
    }

    var body: some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(.headline)
                .frame(width: 32, alignment: .leading)
            Text(displayName)
                .font(.body)
            Spacer()
            Text(timeText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    RankingRowView(rank: 1, displayName: "パパ", minutes: 200)
        .padding()
}
