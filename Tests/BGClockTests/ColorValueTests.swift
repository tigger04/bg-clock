// ABOUTME: Tests for ColorValue hex string and RGBA object decoding.
// Validates parsing of #RRGGBB, #RRGGBBAA, and {r,g,b,a} formats.

import Foundation
import Testing
@testable import BGClock

@Suite("ColorValue decoding")
struct ColorValueTests {

    @Test("Decode hex string #RRGGBB parses correctly")
    func colorValue_decodeHexString_parsesCorrectly() throws {
        let json = "\"#FF0000\"".data(using: .utf8)!
        let color = try JSONDecoder().decode(ColorValue.self, from: json)
        #expect(color.r == 1.0)
        #expect(color.g == 0.0)
        #expect(color.b == 0.0)
        #expect(color.a == 1.0)
    }

    @Test("Decode hex string #RRGGBBAA parses alpha correctly")
    func colorValue_decodeHexWithAlpha_parsesCorrectly() throws {
        let json = "\"#00FF0080\"".data(using: .utf8)!
        let color = try JSONDecoder().decode(ColorValue.self, from: json)
        #expect(color.r == 0.0)
        #expect(color.g == 1.0)
        #expect(color.b == 0.0)
        #expect(abs(color.a - 128.0 / 255.0) < 0.01)
    }

    @Test("Decode RGBA object parses correctly")
    func colorValue_decodeRGBAObject_parsesCorrectly() throws {
        let json = """
        { "r": 0.5, "g": 0.25, "b": 0.75, "a": 0.8 }
        """.data(using: .utf8)!
        let color = try JSONDecoder().decode(ColorValue.self, from: json)
        #expect(color.r == 0.5)
        #expect(color.g == 0.25)
        #expect(color.b == 0.75)
        #expect(color.a == 0.8)
    }

    @Test("Decode RGBA object without alpha defaults to 1.0")
    func colorValue_decodeRGBObjectNoAlpha_defaultsTo1() throws {
        let json = """
        { "r": 0.5, "g": 0.25, "b": 0.75 }
        """.data(using: .utf8)!
        let color = try JSONDecoder().decode(ColorValue.self, from: json)
        #expect(color.a == 1.0)
    }

    @Test("Encode then decode round trip preserves values")
    func colorValue_roundTrip_encodeThenDecode() throws {
        let original = ColorValue(r: 0.1, g: 0.2, b: 0.3, a: 0.4)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ColorValue.self, from: data)
        #expect(decoded == original)
    }

    @Test("Decode hex string #0000FF parses blue correctly")
    func colorValue_decodeBlueHex_parsesCorrectly() throws {
        let json = "\"#0000FF\"".data(using: .utf8)!
        let color = try JSONDecoder().decode(ColorValue.self, from: json)
        #expect(color.r == 0.0)
        #expect(color.g == 0.0)
        #expect(color.b == 1.0)
    }
}
