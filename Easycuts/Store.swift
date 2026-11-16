import SwiftUI

/// One button on the launcher. `shortcutName` must match a shortcut in the Shortcuts app exactly.
struct LauncherItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var shortcutName: String
    var symbol: String
    var colorName: String
    var folder: String
    var returnAfter: Bool

    static func blank() -> LauncherItem {
        LauncherItem(title: "", shortcutName: "", symbol: "bolt.fill", colorName: "blue", folder: "", returnAfter: false)
    }

    var displayTitle: String {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? shortcutName : trimmed
    }
}

final class LauncherStore: ObservableObject {
    @Published private(set) var items: [LauncherItem] = []
    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = dir.appendingPathComponent("launcher.json")
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([LauncherItem].self, from: data) {
            items = decoded
        }
    }

    /// Folder names in the order they first appear. Buttons without a folder come first.
    var folders: [String] {
        var seen: [String] = []
        for item in items where !seen.contains(item.folder) {
            seen.append(item.folder)
        }
        if let index = seen.firstIndex(of: ""), index != 0 {
            seen.remove(at: index)
            seen.insert("", at: 0)
        }
        return seen
    }

    func items(in folder: String) -> [LauncherItem] {
        items.filter { $0.folder == folder }
    }

    func contains(_ item: LauncherItem) -> Bool {
        items.contains { $0.id == item.id }
    }

    func hasShortcut(named name: String) -> Bool {
        items.contains { $0.shortcutName.caseInsensitiveCompare(name) == .orderedSame }
    }

    func upsert(_ item: LauncherItem) {
        var cleaned = item
        cleaned.shortcutName = item.shortcutName.trimmingCharacters(in: .whitespacesAndNewlines)
        cleaned.folder = item.folder.trimmingCharacters(in: .whitespacesAndNewlines)
        if let index = items.firstIndex(where: { $0.id == cleaned.id }) {
            items[index] = cleaned
        } else {
            items.append(cleaned)
        }
        save()
    }

    func delete(_ item: LauncherItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}

enum Palette {
    static let names = ["blue", "indigo", "purple", "pink", "red", "orange", "yellow", "green", "teal", "gray"]

    static func color(_ name: String) -> Color {
        switch name {
        case "indigo": return .indigo
        case "purple": return .purple
        case "pink": return .pink
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "teal": return .teal
        case "gray": return .gray
        default: return .blue
        }
    }
}

enum Symbols {
    static let all = [
        "bolt.fill", "house.fill", "car.fill", "moon.fill", "sun.max.fill", "alarm.fill",
        "timer", "music.note", "message.fill", "phone.fill", "envelope.fill", "camera.fill",
        "photo.fill", "map.fill", "location.fill", "cart.fill", "heart.fill", "star.fill",
        "battery.100", "wifi", "lightbulb.fill", "figure.walk", "book.fill", "gamecontroller.fill",
        "bed.double.fill", "cup.and.saucer.fill", "briefcase.fill", "graduationcap.fill", "play.fill", "speaker.wave.2.fill"
    ]
}

/// Links into Apple's Shortcuts app. These are the only doors Apple gives other apps.
enum ShortcutLinks {
    static let openApp = URL(string: "shortcuts://")!
    static let create = URL(string: "shortcuts://create-shortcut")!

    static func run(_ name: String, returnAfter: Bool) -> URL? {
        var components = URLComponents()
        components.scheme = "shortcuts"
        components.host = "x-callback-url"
        components.path = "/run-shortcut"
        var query = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "x-error", value: "easycuts://error")
        ]
        if returnAfter {
            query.append(URLQueryItem(name: "x-success", value: "easycuts://done"))
            query.append(URLQueryItem(name: "x-cancel", value: "easycuts://done"))
        }
        components.queryItems = query
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
        return components.url
    }

    static func gallerySearch(_ text: String) -> URL? {
        var components = URLComponents()
        components.scheme = "shortcuts"
        components.host = "gallery"
        components.path = "/search"
        components.queryItems = [URLQueryItem(name: "query", value: text)]
        return components.url
    }
}
