// ABOUTME: Codable configuration struct for all clock visual parameters.
// Supports partial JSON decoding — missing fields fall back to defaults.

import Foundation

struct ClockConfiguration: Codable, Sendable {
    var position: Position
    var sizePercent: Double
    var secondHand: HandConfig
    var minuteHand: HandConfig
    var hourHand: HandConfig
    var majorMarker: MarkerConfig
    var minorMarker: MarkerConfig
    var disc: DiscConfig
    var backgroundBlur: Double
    var dateCenter: DateCenterConfig
    var dayOnMinute: HandLabelConfig
    var monthOnHour: HandLabelConfig

    init(
        position: Position = .init(),
        sizePercent: Double = 30.0,
        secondHand: HandConfig = .defaultSecond,
        minuteHand: HandConfig = .defaultMinute,
        hourHand: HandConfig = .defaultHour,
        majorMarker: MarkerConfig = .defaultMajor,
        minorMarker: MarkerConfig = .defaultMinor,
        disc: DiscConfig = .init(),
        backgroundBlur: Double = 0.0,
        dateCenter: DateCenterConfig = .init(),
        dayOnMinute: HandLabelConfig = .defaultDay,
        monthOnHour: HandLabelConfig = .defaultMonth
    ) {
        self.position = position
        self.sizePercent = sizePercent
        self.secondHand = secondHand
        self.minuteHand = minuteHand
        self.hourHand = hourHand
        self.majorMarker = majorMarker
        self.minorMarker = minorMarker
        self.disc = disc
        self.backgroundBlur = backgroundBlur
        self.dateCenter = dateCenter
        self.dayOnMinute = dayOnMinute
        self.monthOnHour = monthOnHour
    }

    init(from decoder: Decoder) throws {
        let defaults = ClockConfiguration()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        position = try container.decodeIfPresent(Position.self, forKey: .position) ?? defaults.position
        sizePercent = try container.decodeIfPresent(Double.self, forKey: .sizePercent) ?? defaults.sizePercent
        secondHand = try container.decodeIfPresent(HandConfig.self, forKey: .secondHand) ?? defaults.secondHand
        minuteHand = try container.decodeIfPresent(HandConfig.self, forKey: .minuteHand) ?? defaults.minuteHand
        hourHand = try container.decodeIfPresent(HandConfig.self, forKey: .hourHand) ?? defaults.hourHand
        majorMarker = try container.decodeIfPresent(MarkerConfig.self, forKey: .majorMarker) ?? defaults.majorMarker
        minorMarker = try container.decodeIfPresent(MarkerConfig.self, forKey: .minorMarker) ?? defaults.minorMarker
        disc = try container.decodeIfPresent(DiscConfig.self, forKey: .disc) ?? defaults.disc
        backgroundBlur = try container.decodeIfPresent(Double.self, forKey: .backgroundBlur) ?? defaults.backgroundBlur
        dateCenter = try container.decodeIfPresent(DateCenterConfig.self, forKey: .dateCenter) ?? defaults.dateCenter
        dayOnMinute = try container.decodeIfPresent(HandLabelConfig.self, forKey: .dayOnMinute) ?? defaults.dayOnMinute
        monthOnHour = try container.decodeIfPresent(HandLabelConfig.self, forKey: .monthOnHour) ?? defaults.monthOnHour
    }
}

// MARK: - Sub-configurations

struct Position: Codable, Sendable {
    var xPercent: Double
    var yPercent: Double

    init(xPercent: Double = 35.0, yPercent: Double = 20.0) {
        self.xPercent = xPercent
        self.yPercent = yPercent
    }
}

struct HandConfig: Codable, Sendable {
    var color: ColorValue
    var width: Double
    var lengthPercent: Double

    static let defaultSecond = HandConfig(
        color: ColorValue(r: 0.82, g: 0.38, b: 0.56, a: 0.35),
        width: 2.0,
        lengthPercent: 100.0
    )

    static let defaultMinute = HandConfig(
        color: ColorValue(r: 0.35, g: 0.45, b: 0.60, a: 0.10),
        width: 16.0,
        lengthPercent: 58.0
    )

    static let defaultHour = HandConfig(
        color: ColorValue(r: 0.40, g: 0.40, b: 0.50, a: 0.10),
        width: 23.0,
        lengthPercent: 35.0
    )
}

struct MarkerConfig: Codable, Sendable {
    var color: ColorValue
    var width: Double
    var lengthPercent: Double

    static let defaultMajor = MarkerConfig(
        color: ColorValue(r: 0.80, g: 0.80, b: 0.80, a: 0.50),
        width: 8.0,
        lengthPercent: 8.0
    )

    static let defaultMinor = MarkerConfig(
        color: ColorValue(r: 0.80, g: 0.80, b: 0.80, a: 0.50),
        width: 2.0,
        lengthPercent: 2.0
    )
}

struct DiscConfig: Codable, Sendable {
    var sizePercent: Double
    var color: ColorValue
    var borderWidth: Double
    var borderColor: ColorValue
    var blur: Double

    init(
        sizePercent: Double = 96.0,
        color: ColorValue = ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.15),
        borderWidth: Double = 0.0,
        borderColor: ColorValue = ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.0),
        blur: Double = 5.0
    ) {
        self.sizePercent = sizePercent
        self.color = color
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.blur = blur
    }
}

struct DateCenterConfig: Codable, Sendable {
    var enabled: Bool
    var fontSize: Double
    var color: ColorValue
    var backgroundColor: ColorValue
    var borderColor: ColorValue
    var borderWidth: Double
    var discSizePercent: Double
    var fontFamily: String
    var fontWeight: Double
    var blur: Double

    init(
        enabled: Bool = true,
        fontSize: Double = 44.0,
        color: ColorValue = ColorValue(r: 0.60, g: 0.60, b: 0.60, a: 0.80),
        backgroundColor: ColorValue = ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.45),
        borderColor: ColorValue = ColorValue(r: 1.0, g: 1.0, b: 1.0, a: 0.20),
        borderWidth: Double = 0.0,
        discSizePercent: Double = 15.0,
        fontFamily: String = "monospace",
        fontWeight: Double = 300.0,
        blur: Double = 5.0
    ) {
        self.enabled = enabled
        self.fontSize = fontSize
        self.color = color
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.discSizePercent = discSizePercent
        self.fontFamily = fontFamily
        self.fontWeight = fontWeight
        self.blur = blur
    }
}

struct HandLabelConfig: Codable, Sendable {
    var enabled: Bool
    var fontSize: Double
    var color: ColorValue
    var backgroundColor: ColorValue
    var borderRadius: Double
    var padding: Double
    var offsetPercent: Double
    var fontFamily: String
    var fontWeight: Double
    var allCaps: Bool
    var stretchFactor: Double
    var letterSpacing: Double

    static let defaultDay = HandLabelConfig(
        enabled: true,
        fontSize: 16.0,
        color: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.80),
        backgroundColor: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.0),
        borderRadius: 8.0,
        padding: 4.0,
        offsetPercent: 60.0,
        fontFamily: "monospace",
        fontWeight: 500.0,
        allCaps: true,
        stretchFactor: 1.2,
        letterSpacing: 10.0
    )

    static let defaultMonth = HandLabelConfig(
        enabled: true,
        fontSize: 20.0,
        color: ColorValue(r: 0.0, g: 0.0, b: 0.20, a: 0.60),
        backgroundColor: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.0),
        borderRadius: 0.0,
        padding: 4.0,
        offsetPercent: 60.0,
        fontFamily: "monospace",
        fontWeight: 500.0,
        allCaps: true,
        stretchFactor: 1.1,
        letterSpacing: 2.0
    )
}
