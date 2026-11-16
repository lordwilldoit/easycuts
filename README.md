# Easycuts

A simpler front door for Apple's Shortcuts app.

- **My Buttons**: big one-tap buttons that run your shortcuts, grouped into folders.
- **Ideas**: 14 useful shortcuts explained in plain steps, each with a ready-made button.

## Getting the IPA

Every push to `main` builds an unsigned IPA on GitHub's Mac servers.
Open the **Actions** tab, pick the latest "Build IPA" run, and download **Easycuts-ipa**.
Unzip it and sideload `Easycuts.ipa` with AltStore or Sideloadly.

## Building on a Mac

    brew install xcodegen
    xcodegen generate
    open Easycuts.xcodeproj
