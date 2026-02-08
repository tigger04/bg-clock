// ABOUTME: Tests for DesktopWindowManager configuration constants.
// Validates window level, transparency, and click-through settings.

import AppKit
import Testing
@testable import BGClock

@Suite("DesktopWindowManager configuration")
struct DesktopWindowConfigTests {

    @Test("Desktop window level is one above desktop")
    func desktopWindowLevel_isAboveDesktop() {
        let desktopLevel = Int(CGWindowLevelForKey(.desktopWindow))
        #expect(DesktopWindowConfig.windowLevel == desktopLevel + 1)
    }

    @Test("Window is configured as non-opaque")
    func windowConfig_isNotOpaque() {
        #expect(DesktopWindowConfig.isOpaque == false)
    }

    @Test("Window ignores mouse events for click-through")
    func windowConfig_ignoresMouseEvents() {
        #expect(DesktopWindowConfig.ignoresMouseEvents == true)
    }

    @Test("Window has no shadow")
    func windowConfig_hasNoShadow() {
        #expect(DesktopWindowConfig.hasShadow == false)
    }

    @Test("Window joins all spaces and is stationary")
    func windowConfig_collectionBehavior_containsRequiredFlags() {
        let behavior = DesktopWindowConfig.collectionBehavior
        #expect(behavior.contains(.canJoinAllSpaces))
        #expect(behavior.contains(.stationary))
    }
}
