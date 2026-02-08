// ABOUTME: Tests for ClockConfiguration JSON decoding.
// Validates complete, partial, empty, and invalid JSON handling.

import Foundation
import Testing
@testable import BGClock

@Suite("ClockConfiguration decoding")
struct ClockConfigurationTests {

    @Test("Decode complete JSON config populates all fields")
    func configuration_decodeComplete_allFieldsPopulated() throws {
        let json = """
        {
            "sizePercent": 25.0,
            "backgroundBlur": 3.0,
            "position": { "xPercent": 50.0, "yPercent": 50.0 },
            "secondHand": { "color": { "r": 1.0, "g": 0.0, "b": 0.0, "a": 0.5 }, "width": 3.0, "lengthPercent": 90.0 },
            "minuteHand": { "color": { "r": 0.0, "g": 1.0, "b": 0.0, "a": 0.5 }, "width": 10.0, "lengthPercent": 50.0 },
            "hourHand": { "color": { "r": 0.0, "g": 0.0, "b": 1.0, "a": 0.5 }, "width": 20.0, "lengthPercent": 30.0 },
            "majorMarker": { "color": { "r": 1.0, "g": 1.0, "b": 1.0, "a": 1.0 }, "width": 5.0, "lengthPercent": 10.0 },
            "minorMarker": { "color": { "r": 0.5, "g": 0.5, "b": 0.5, "a": 0.5 }, "width": 1.0, "lengthPercent": 3.0 },
            "disc": { "sizePercent": 90.0, "color": { "r": 0.0, "g": 0.0, "b": 0.0, "a": 0.2 }, "borderWidth": 1.0, "borderColor": { "r": 1.0, "g": 1.0, "b": 1.0, "a": 0.5 }, "blur": 10.0 },
            "dateCenter": { "enabled": false, "fontSize": 30.0, "color": { "r": 1.0, "g": 1.0, "b": 1.0, "a": 1.0 }, "backgroundColor": { "r": 0.0, "g": 0.0, "b": 0.0, "a": 0.5 }, "borderColor": { "r": 0.0, "g": 0.0, "b": 0.0, "a": 0.0 }, "borderWidth": 0.0, "discSizePercent": 12.0, "fontFamily": "Helvetica", "fontWeight": 400.0, "blur": 3.0 },
            "dayOnMinute": { "enabled": false, "fontSize": 14.0, "color": { "r": 0.0, "g": 0.0, "b": 0.0, "a": 1.0 }, "backgroundColor": { "r": 0.0, "g": 0.0, "b": 0.0, "a": 0.0 }, "borderRadius": 4.0, "padding": 2.0, "offsetPercent": 50.0, "fontFamily": "Helvetica", "fontWeight": 600.0, "allCaps": false, "stretchFactor": 1.0, "letterSpacing": 5.0 },
            "monthOnHour": { "enabled": false, "fontSize": 18.0, "color": { "r": 0.0, "g": 0.0, "b": 0.0, "a": 1.0 }, "backgroundColor": { "r": 0.0, "g": 0.0, "b": 0.0, "a": 0.0 }, "borderRadius": 0.0, "padding": 2.0, "offsetPercent": 55.0, "fontFamily": "Helvetica", "fontWeight": 600.0, "allCaps": false, "stretchFactor": 1.0, "letterSpacing": 3.0 }
        }
        """.data(using: .utf8)!

        let config = try JSONDecoder().decode(ClockConfiguration.self, from: json)
        #expect(config.sizePercent == 25.0)
        #expect(config.backgroundBlur == 3.0)
        #expect(config.position.xPercent == 50.0)
        #expect(config.secondHand.width == 3.0)
        #expect(config.dateCenter.enabled == false)
        #expect(config.dayOnMinute.allCaps == false)
    }

    @Test("Decode partial JSON uses defaults for missing fields")
    func configuration_decodePartial_missingFieldsUseDefaults() throws {
        let json = """
        { "sizePercent": 20.0 }
        """.data(using: .utf8)!

        let config = try JSONDecoder().decode(ClockConfiguration.self, from: json)
        let defaults = ClockConfiguration()

        #expect(config.sizePercent == 20.0)
        #expect(config.position.xPercent == defaults.position.xPercent)
        #expect(config.secondHand.width == defaults.secondHand.width)
        #expect(config.disc.sizePercent == defaults.disc.sizePercent)
        #expect(config.dateCenter.enabled == defaults.dateCenter.enabled)
        #expect(config.backgroundBlur == defaults.backgroundBlur)
    }

    @Test("Decode empty JSON object returns all defaults")
    func configuration_decodeEmpty_allDefaults() throws {
        let json = "{}".data(using: .utf8)!

        let config = try JSONDecoder().decode(ClockConfiguration.self, from: json)
        let defaults = ClockConfiguration()

        #expect(config.sizePercent == defaults.sizePercent)
        #expect(config.position.xPercent == defaults.position.xPercent)
        #expect(config.position.yPercent == defaults.position.yPercent)
        #expect(config.hourHand.lengthPercent == defaults.hourHand.lengthPercent)
        #expect(config.minuteHand.lengthPercent == defaults.minuteHand.lengthPercent)
        #expect(config.secondHand.lengthPercent == defaults.secondHand.lengthPercent)
    }

    @Test("Invalid JSON returns nil from decode helper")
    func configuration_decodeInvalidJSON_returnsNil() {
        let json = "not json at all".data(using: .utf8)!
        let result = ConfigLoader.decode(from: json)
        #expect(result == nil)
    }

    @Test("Default configuration has expected size")
    func configuration_defaults_sizePercent30() {
        let config = ClockConfiguration()
        #expect(config.sizePercent == 50.0)
    }

    @Test("Default configuration has date center enabled")
    func configuration_defaults_dateCenterEnabled() {
        let config = ClockConfiguration()
        #expect(config.dateCenter.enabled == true)
    }

    @Test("Default configuration has day on minute disabled")
    func configuration_defaults_dayOnMinuteDisabled() {
        let config = ClockConfiguration()
        #expect(config.dayOnMinute.enabled == false)
        #expect(config.dayOnMinute.allCaps == true)
    }
}
