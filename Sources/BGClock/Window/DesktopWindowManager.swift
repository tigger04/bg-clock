// ABOUTME: Manages the desktop-level transparent NSWindow for the clock.
// Creates a borderless, click-through window positioned above the wallpaper.

import AppKit
import SwiftUI

/// Configuration constants for the desktop window.
/// Extracted as a struct so they can be validated in unit tests
/// without requiring a running NSApplication.
struct DesktopWindowConfig: Sendable {
    static let windowLevel = Int(CGWindowLevelForKey(.desktopWindow)) + 1
    static let isOpaque = false
    static let ignoresMouseEvents = true
    static let hasShadow = false
    static let collectionBehavior: NSWindow.CollectionBehavior = [
        .canJoinAllSpaces,
        .stationary,
    ]
}

@MainActor
final class DesktopWindowManager {
    private var window: NSWindow?

    func createWindow(with rootView: some View) {
        guard let screen = NSScreen.main else {
            return
        }

        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.level = NSWindow.Level(rawValue: DesktopWindowConfig.windowLevel)
        window.isOpaque = DesktopWindowConfig.isOpaque
        window.backgroundColor = .clear
        window.ignoresMouseEvents = DesktopWindowConfig.ignoresMouseEvents
        window.collectionBehavior = DesktopWindowConfig.collectionBehavior
        window.hasShadow = DesktopWindowConfig.hasShadow

        let hostingView = NSHostingView(rootView: rootView)
        window.contentView = hostingView
        window.orderFront(nil)

        self.window = window
    }
}
