import Foundation

/// A shortcut idea with plain-language build steps.
struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let symbol: String
    let colorName: String
    let category: String
    let shortcutName: String
    let galleryQuery: String
    let steps: [String]

    func launcherItem() -> LauncherItem {
        LauncherItem(title: title, shortcutName: shortcutName, symbol: symbol, colorName: colorName, folder: "", returnAfter: returnAfter)
    }

    /// Shortcuts that open another app should not bounce back to Easycuts.
    var returnAfter: Bool {
        !["Directions Home", "Play My Music", "Quick Note", "Name That Song", "Call Favorite"].contains(shortcutName)
    }

    static let categories = ["Everyday", "Getting around", "Focus and sleep", "Battery and settings", "Fun"]

    static let all: [Recipe] = [
        Recipe(
            title: "Quick Timer",
            summary: "Starts a timer for a length you pick once, like 10 minutes for pasta or 25 for studying.",
            symbol: "timer", colorName: "orange", category: "Everyday",
            shortcutName: "Quick Timer", galleryQuery: "timer",
            steps: [
                "In the search bar at the bottom, type \"Start Timer\" and tap it.",
                "Tap the time in the action and set how long the timer should run."
            ]
        ),
        Recipe(
            title: "Quick Note",
            summary: "Opens a fresh note right away so you can jot something down.",
            symbol: "book.fill", colorName: "yellow", category: "Everyday",
            shortcutName: "Quick Note", galleryQuery: "note",
            steps: [
                "Search for \"Create Note\" and tap it.",
                "Leave the text empty, and make sure \"Open When Run\" is turned on so the note opens for typing."
            ]
        ),
        Recipe(
            title: "Call Favorite",
            summary: "Calls one person you choose, with no scrolling through contacts.",
            symbol: "phone.fill", colorName: "green", category: "Everyday",
            shortcutName: "Call Favorite", galleryQuery: "call",
            steps: [
                "Search for \"Call\" and tap the Call action from Phone.",
                "Tap \"Contact\" in the action and pick the person."
            ]
        ),
        Recipe(
            title: "Morning Weather",
            summary: "Reads today's weather out loud while you get ready.",
            symbol: "sun.max.fill", colorName: "blue", category: "Everyday",
            shortcutName: "Morning Weather", galleryQuery: "weather",
            steps: [
                "Search for \"Get Current Weather\" and tap it.",
                "Search for \"Speak Text\" and tap it. It will read the weather from the step above."
            ]
        ),
        Recipe(
            title: "Log Water",
            summary: "Adds a glass of water to the Health app with one tap.",
            symbol: "cup.and.saucer.fill", colorName: "teal", category: "Everyday",
            shortcutName: "Log Water", galleryQuery: "water",
            steps: [
                "Search for \"Log Health Sample\" and tap it.",
                "Tap \"Type\" and choose Water.",
                "Set the amount for one glass, for example 250 mL."
            ]
        ),
        Recipe(
            title: "Directions Home",
            summary: "Opens Maps with the route home from wherever you are.",
            symbol: "house.fill", colorName: "indigo", category: "Getting around",
            shortcutName: "Directions Home", galleryQuery: "directions home",
            steps: [
                "Search for \"Directions\" and tap the Maps action that opens directions.",
                "Tap the destination in the action and enter your home address."
            ]
        ),
        Recipe(
            title: "Text My ETA",
            summary: "Tells someone how long until you get home.",
            symbol: "message.fill", colorName: "green", category: "Getting around",
            shortcutName: "Text My ETA", galleryQuery: "ETA",
            steps: [
                "Search for \"Get Travel Time\" and tap it. Set the destination to your home address.",
                "Search for \"Send Message\" and tap it.",
                "In the message, type something like \"Home in\" and then pick Travel Time from the suggestions above the keyboard.",
                "Tap \"Recipients\" and choose who gets the text."
            ]
        ),
        Recipe(
            title: "Bedtime",
            summary: "Turns on Sleep Focus, dims the screen, and lowers the volume.",
            symbol: "bed.double.fill", colorName: "purple", category: "Focus and sleep",
            shortcutName: "Bedtime", galleryQuery: "bedtime",
            steps: [
                "Search for \"Set Focus\" and tap it. Choose Sleep, and set it to turn On.",
                "Search for \"Set Brightness\" and tap it. Drag it down to about 20%.",
                "Search for \"Set Volume\" and tap it. Drag it down to about 20%."
            ]
        ),
        Recipe(
            title: "Quiet for an Hour",
            summary: "Silences notifications for one hour, then turns them back on by itself.",
            symbol: "moon.fill", colorName: "indigo", category: "Focus and sleep",
            shortcutName: "Quiet for an Hour", galleryQuery: "do not disturb",
            steps: [
                "Search for \"Set Focus\" and tap it. Choose Do Not Disturb and set it to turn On.",
                "Tap \"Until\" and choose Time, then set it to one hour from now. To get a fresh hour every time, choose \"Ask Each Time\" instead."
            ]
        ),
        Recipe(
            title: "Save Battery",
            summary: "Switches on Low Power Mode and dims the screen when you're running low.",
            symbol: "battery.100", colorName: "yellow", category: "Battery and settings",
            shortcutName: "Save Battery", galleryQuery: "battery",
            steps: [
                "Search for \"Set Low Power Mode\" and tap it. Make sure it says Turn On.",
                "Search for \"Set Brightness\" and tap it. Drag it down to about 30%."
            ]
        ),
        Recipe(
            title: "Dark Mode Switch",
            summary: "Flips between light and dark appearance.",
            symbol: "lightbulb.fill", colorName: "gray", category: "Battery and settings",
            shortcutName: "Dark Mode Switch", galleryQuery: "dark mode",
            steps: [
                "Search for \"Set Appearance\" and tap it.",
                "Tap \"Turn\" in the action and change it to Toggle."
            ]
        ),
        Recipe(
            title: "Wi-Fi Off",
            summary: "Turns Wi-Fi fully off, which Control Center doesn't do.",
            symbol: "wifi", colorName: "blue", category: "Battery and settings",
            shortcutName: "Wi-Fi Off", galleryQuery: "wifi",
            steps: [
                "Search for \"Set Wi-Fi\" and tap it.",
                "Tap \"On\" in the action so it changes to Off."
            ]
        ),
        Recipe(
            title: "Play My Music",
            summary: "Starts a playlist you pick, shuffled.",
            symbol: "music.note", colorName: "pink", category: "Fun",
            shortcutName: "Play My Music", galleryQuery: "playlist",
            steps: [
                "Search for \"Play Music\" and tap it.",
                "Tap \"Music\" in the action and choose a playlist from your library.",
                "Tap the arrow on the action and set Shuffle to Songs."
            ]
        ),
        Recipe(
            title: "Name That Song",
            summary: "Listens to what's playing around you and tells you the song.",
            symbol: "speaker.wave.2.fill", colorName: "red", category: "Fun",
            shortcutName: "Name That Song", galleryQuery: "shazam",
            steps: [
                "Search for \"Recognize Music\" and tap it. That one action is the whole shortcut."
            ]
        )
    ]
}
