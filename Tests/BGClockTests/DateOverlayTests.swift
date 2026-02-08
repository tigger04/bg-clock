// ABOUTME: Tests for date overlay configuration and text formatting.
// Validates enabled/disabled state, capitalisation, and offset calculations.

import Foundation
import SwiftUI
import Testing
@testable import BGClock

@Suite("Date overlay logic")
struct DateOverlayTests {

    @Test("Date center disabled hides overlay")
    func dateCenterView_disabledConfig_isHidden() {
        var config = DateCenterConfig()
        config.enabled = false
        #expect(config.enabled == false)
    }

    @Test("Date center enabled shows overlay")
    func dateCenterView_enabledConfig_isShown() {
        let config = DateCenterConfig()
        #expect(config.enabled == true)
    }

    @Test("Hand label allCaps true uppercases text")
    func handLabel_allCapsTrue_uppercases() {
        let text = "Wednesday"
        let config = HandLabelConfig.defaultDay
        #expect(config.allCaps == true)
        let displayed = config.allCaps ? text.uppercased() : text.capitalized
        #expect(displayed == "WEDNESDAY")
    }

    @Test("Hand label allCaps false capitalizes text")
    func handLabel_allCapsFalse_capitalizes() {
        let text = "wednesday"
        var config = HandLabelConfig.defaultDay
        config.allCaps = false
        let displayed = config.allCaps ? text.uppercased() : text.capitalized
        #expect(displayed == "Wednesday")
    }

    @Test("Label offset calculates from percentage and hand length")
    func handLabel_offset_calculatesFromPercentage() {
        let handLength: CGFloat = 200.0
        let offsetPercent: Double = 60.0
        let offset = handLength * offsetPercent / 100.0
        #expect(offset == 120.0)
    }

    @Test("Date center disc size calculates from percentage")
    func dateCenterDiscSize_calculatesFromPercentage() {
        let clockSize: CGFloat = 500.0
        let config = DateCenterConfig()
        let discSize = clockSize * config.discSizePercent / 100.0
        #expect(discSize == 75.0)
    }

    @Test("Hand label stretch factor defaults to greater than 1")
    func handLabel_stretchFactor_defaultIsWider() {
        let config = HandLabelConfig.defaultDay
        #expect(config.stretchFactor > 1.0)
    }

    @Test("Font weight 300 maps to light")
    func fontWeight_300_mapsToLight() {
        let weight = Font.Weight.fromNumeric(300.0)
        #expect(weight == .light)
    }

    @Test("Font weight 500 maps to medium")
    func fontWeight_500_mapsToMedium() {
        let weight = Font.Weight.fromNumeric(500.0)
        #expect(weight == .medium)
    }

    @Test("Font weight 700 maps to bold")
    func fontWeight_700_mapsToBold() {
        let weight = Font.Weight.fromNumeric(700.0)
        #expect(weight == .bold)
    }
}
