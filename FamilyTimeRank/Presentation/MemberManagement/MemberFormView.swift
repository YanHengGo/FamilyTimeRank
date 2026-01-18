import SwiftUI

struct MemberFormView: View {
    let title: String
    let initialDisplayName: String
    let initialRole: MemberRole
    let initialDeviceModel: String
    let onSave: (String, MemberRole, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var displayName: String
    @State private var role: MemberRole
    @State private var deviceModel: String

    init(
        title: String,
        initialDisplayName: String,
        initialRole: MemberRole,
        initialDeviceModel: String,
        onSave: @escaping (String, MemberRole, String) -> Void
    ) {
        self.title = title
        self.initialDisplayName = initialDisplayName
        self.initialRole = initialRole
        self.initialDeviceModel = initialDeviceModel
        self.onSave = onSave
        _displayName = State(initialValue: initialDisplayName)
        _role = State(initialValue: initialRole)
        _deviceModel = State(initialValue: initialDeviceModel)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("表示名")) {
                    TextField("表示名", text: $displayName)
                        .textInputAutocapitalization(.never)
                }
                Section(header: Text("端末名")) {
                    TextField("端末名", text: $deviceModel)
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
                        onSave(displayName, role, deviceModel)
                        dismiss()
                    }
                    .disabled(
                        displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        deviceModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
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
