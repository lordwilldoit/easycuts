import SwiftUI

@main
struct EasycutsApp: App {
    @StateObject private var store = LauncherStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}

struct RootView: View {
    @State private var errorMessage = ""
    @State private var showError = false

    var body: some View {
        TabView {
            LauncherView()
                .tabItem {
                    Label("My Buttons", systemImage: "square.grid.2x2.fill")
                }
            GalleryView()
                .tabItem {
                    Label("Ideas", systemImage: "sparkles")
                }
        }
        .onOpenURL { url in
            // The Shortcuts app calls easycuts://error when a shortcut can't run.
            guard url.scheme == "easycuts", url.host == "error" else { return }
            let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
            let detail = items?.first(where: { $0.name == "errorMessage" })?.value
            errorMessage = detail ?? "Check that the shortcut name matches the one in the Shortcuts app exactly."
            showError = true
        }
        .alert("That shortcut didn't run", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
}
