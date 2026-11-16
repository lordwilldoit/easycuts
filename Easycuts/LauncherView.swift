import SwiftUI

struct LauncherView: View {
    @EnvironmentObject private var store: LauncherStore
    @Environment(\.openURL) private var openURL
    @State private var editing: LauncherItem?

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if store.items.isEmpty {
                    emptyState
                } else {
                    grid
                }
            }
            .navigationTitle("My Buttons")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editing = LauncherItem.blank()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add a button")
                }
            }
            .sheet(item: $editing) { item in
                EditItemView(item: item, isNew: !store.contains(item))
            }
        }
    }

    private var grid: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(store.folders, id: \.self) { folder in
                    VStack(alignment: .leading, spacing: 12) {
                        if !folder.isEmpty {
                            Text(folder)
                                .font(.title3.weight(.semibold))
                        }
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(store.items(in: folder)) { item in
                                Button {
                                    run(item)
                                } label: {
                                    TileView(item: item)
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button {
                                        editing = item
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    Button(role: .destructive) {
                                        store.delete(item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                Text("Tap a button to run it. Hold a button to edit or delete it.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.grid.2x2.fill")
                .font(.system(size: 52))
                .foregroundColor(.blue)
            Text("No buttons yet")
                .font(.title2.weight(.bold))
            Text("Each button runs one of your shortcuts with a single tap. Add one you already have, or pick an idea to build.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Button {
                editing = LauncherItem.blank()
            } label: {
                Text("Add a button")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            Text("Need a shortcut first? Open the Ideas tab.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(32)
    }

    private func run(_ item: LauncherItem) {
        if let url = ShortcutLinks.run(item.shortcutName, returnAfter: item.returnAfter) {
            openURL(url)
        }
    }
}

struct TileView: View {
    let item: LauncherItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: item.symbol)
                .font(.system(size: 26, weight: .semibold))
            Spacer(minLength: 0)
            Text(item.displayTitle)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .foregroundColor(.white)
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 108, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Palette.color(item.colorName).gradient)
        )
    }
}
