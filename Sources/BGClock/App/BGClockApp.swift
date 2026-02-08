// ABOUTME: Main entry point for the bg-clock application.
// Uses AppKit lifecycle directly for reliable desktop window creation.

import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let windowManager = DesktopWindowManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("bg-clock: applicationDidFinishLaunching")
        NSLog("bg-clock: screens=%d main=%@", NSScreen.screens.count, NSScreen.main?.frame.debugDescription ?? "nil")
        NSApplication.shared.setActivationPolicy(.accessory)
        windowManager.createWindow()
        NSLog("bg-clock: window created")
    }
}

@main
enum Main {
    static func main() {
        NSLog("bg-clock: main() starting")
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        NSLog("bg-clock: calling app.run()")
        app.run()
    }
}
