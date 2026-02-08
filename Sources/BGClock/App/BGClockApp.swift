// ABOUTME: Main entry point for the bg-clock application.
// Configures the app as a background-only accessory (no Dock icon).

import SwiftUI

@main
struct BGClockApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let windowManager = DesktopWindowManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.accessory)
        windowManager.createWindow()
    }
}
