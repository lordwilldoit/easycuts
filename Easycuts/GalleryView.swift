import SwiftUI

struct GalleryView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Simple shortcuts you can build in a minute. Each one comes with plain steps and a button for your launcher.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                ForEach(Recipe.categories, id: \.self) { category in
                    Section(category) {
                        ForEach(Recipe.all.filter { $0.category == category }) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                RecipeRow(recipe: recipe)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Ideas")
        }
    }
}

struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: recipe.symbol)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Palette.color(recipe.colorName).gradient)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(recipe.title)
                    .font(.headline)
                Text(recipe.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct RecipeDetailView: View {
    @EnvironmentObject private var store: LauncherStore
    @Environment(\.openURL) private var openURL
    let recipe: Recipe

    private var alreadyAdded: Bool {
        store.hasShortcut(named: recipe.shortcutName)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HStack(spacing: 14) {
                    Image(systemName: recipe.symbol)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Palette.color(recipe.colorName).gradient)
                        )
                    Text(recipe.summary)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 14) {
                    Text("How to build it")
                        .font(.title3.weight(.semibold))
                    StepRow(number: 1, text: "Tap \"Start a new shortcut\" below. The Shortcuts app opens on an empty shortcut.")
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        StepRow(number: index + 2, text: step)
                    }
                    StepRow(number: recipe.steps.count + 2, text: "Tap the name at the top, choose Rename, and call it \"\(recipe.shortcutName)\". Then tap Done.")
                }

                VStack(spacing: 12) {
                    Button {
                        openURL(ShortcutLinks.create)
                    } label: {
                        Text("Start a new shortcut")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        store.upsert(recipe.launcherItem())
                    } label: {
                        Text(alreadyAdded ? "Button added to My Buttons" : "Add its button to My Buttons")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.bordered)
                    .disabled(alreadyAdded)

                    Button {
                        if let url = ShortcutLinks.gallerySearch(recipe.galleryQuery) {
                            openURL(url)
                        }
                    } label: {
                        Text("Look for a ready-made one in Apple's Gallery")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                    }
                }

                Text("The button only works once a shortcut with that exact name exists in the Shortcuts app.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StepRow: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.subheadline.weight(.bold))
                .foregroundColor(.white)
                .frame(width: 26, height: 26)
                .background(Circle().fill(Color.blue))
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
