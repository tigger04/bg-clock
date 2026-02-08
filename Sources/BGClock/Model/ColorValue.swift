// ABOUTME: A Codable colour representation for JSON configuration.
// Supports decoding from hex strings (#RRGGBB, #RRGGBBAA) and RGBA objects.

import SwiftUI

struct ColorValue: Codable, Sendable, Equatable {
    var r: Double
    var g: Double
    var b: Double
    var a: Double

    var color: Color {
        Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    var nsColor: NSColor {
        NSColor(srgbRed: r, green: g, blue: b, alpha: a)
    }

    init(r: Double, g: Double, b: Double, a: Double = 1.0) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let hexString = try? container.decode(String.self) {
            self = try ColorValue.fromHex(hexString)
            return
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.r = try container.decode(Double.self, forKey: .r)
        self.g = try container.decode(Double.self, forKey: .g)
        self.b = try container.decode(Double.self, forKey: .b)
        self.a = try container.decodeIfPresent(Double.self, forKey: .a) ?? 1.0
    }

    private enum CodingKeys: String, CodingKey {
        case r, g, b, a
    }

    static func fromHex(_ hex: String) throws -> ColorValue {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        guard hexSanitized.count == 6 || hexSanitized.count == 8 else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Invalid hex colour string: \(hex). Expected #RRGGBB or #RRGGBBAA."
                )
            )
        }

        var hexValue: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&hexValue) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Cannot parse hex colour: \(hex)"
                )
            )
        }

        if hexSanitized.count == 8 {
            return ColorValue(
                r: Double((hexValue >> 24) & 0xFF) / 255.0,
                g: Double((hexValue >> 16) & 0xFF) / 255.0,
                b: Double((hexValue >> 8) & 0xFF) / 255.0,
                a: Double(hexValue & 0xFF) / 255.0
            )
        } else {
            return ColorValue(
                r: Double((hexValue >> 16) & 0xFF) / 255.0,
                g: Double((hexValue >> 8) & 0xFF) / 255.0,
                b: Double(hexValue & 0xFF) / 255.0,
                a: 1.0
            )
        }
    }
}
