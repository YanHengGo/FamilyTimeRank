import SwiftUI

struct MemberFormView: View {
    let title: String
    let initialDisplayName: String
    let initialRole: MemberRole
    let onSave: (String, MemberRole) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var displayName: String
    @State private var role: MemberRole

    init(
        title: String,
        initialDisplayName: String,
        initialRole: MemberRole,
        onSave: @escaping (String, MemberRole) -> Void
    ) {
        self.title = title
        self.initialDisplayName = initialDisplayName
        self.initialRole = initialRole
        self.onSave = onSave
        _displayName = State(initialValue: initialDisplayName)
        _role = State(initialValue: initialRole)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("表示名")) {
                    TextField("表示名", text: $displayName)
                        .textInputAutocapitalization(.never)
                }
                Section(header: Text("役割")) {
                    Picker("役割", selection: $role) {
                        ForEach(MemberRole.allCases, id: \.self) { role in
                            Text(role.displayName).tag(role)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        onSave(displayName, role)
                        dismiss()
                    }
                    .disabled(displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

private extension MemberRole {
    var displayName: String {
        switch self {
        case .dad:
            return "パパ"
        case .mom:
            return "ママ"
        case .son:
            return "息子"
        case .daughter:
            return "娘"
        }
    }
}
