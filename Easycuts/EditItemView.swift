import SwiftUI

struct EditItemView: View {
    @EnvironmentObject private var store: LauncherStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var draft: LauncherItem
    private let isNew: Bool

    private let symbolColumns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)

    init(item: LauncherItem, isNew: Bool) {
        _draft = State(initialValue: item)
        self.isNew = isNew
    }

    private var canSave: Bool {
        !draft.shortcutName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var otherFolders: [String] {
        store.folders.filter { !$0.isEmpty && $0 != draft.folder }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Shortcut name", text: $draft.shortcutName)
                        .autocorrectionDisabled()
                    Button("Open Shortcuts to check the name") {
                        openURL(ShortcutLinks.openApp)
                    }
                } header: {
                    Text("Which shortcut")
                } footer: {
                    Text("Type the name exactly as it appears in the Shortcuts app, including spaces and capitals.")
                }

                Section {
                    TextField("Label (optional)", text: $draft.title)
                } header: {
                    Text("Button label")
                } footer: {
                    Text("Leave empty to use the shortcut name.")
                }

                Section("Icon") {
                    LazyVGrid(columns: symbolColumns, spacing: 10) {
                        ForEach(Symbols.all, id: \.self) { symbol in
                            Image(systemName: symbol)
                                .font(.system(size: 20))
                                .frame(width: 42, height: 42)
                                .foregroundColor(draft.symbol == symbol ? .white : .primary)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(draft.symbol == symbol ? Palette.color(draft.colorName) : Color.gray.opacity(0.15))
                                )
                                .onTapGesture {
                                    draft.symbol = symbol
                                }
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Color") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Palette.names, id: \.self) { name in
                                Circle()
                                    .fill(Palette.color(name))
                                    .frame(width: 34, height: 34)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: draft.colorName == name ? 3 : 0)
                                            .padding(-4)
                                    )
                                    .onTapGesture {
                                        draft.colorName = name
                                    }
                            }
                        }
                        .padding(6)
                    }
                }

                Section {
                    TextField("Folder (optional)", text: $draft.folder)
                    ForEach(otherFolders, id: \.self) { folder in
                        Button("Use \"\(folder)\"") {
                            draft.folder = folder
                        }
                    }
                } header: {
                    Text("Folder")
                } footer: {
                    Text("Buttons with the same folder name are grouped together.")
                }

                Section {
                    Toggle("Come back here when it finishes", isOn: $draft.returnAfter)
                } footer: {
                    Text("Leave off for shortcuts that open another app, like directions or music.")
                }

                Section {
                    Button("Test it now") {
                        if let url = ShortcutLinks.run(draft.shortcutName.trimmingCharacters(in: .whitespacesAndNewlines), returnAfter: true) {
                            openURL(url)
                        }
                    }
                    .disabled(!canSave)
                    if !isNew {
                        Button("Delete button", role: .destructive) {
                            store.delete(draft)
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle(isNew ? "New Button" : "Edit Button")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.upsert(draft)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
