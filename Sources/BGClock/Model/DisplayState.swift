// ABOUTME: Pure value type for clock layout derived from screen and config.
// Computes clock size and position from percentage-based configuration.

import Foundation

struct DisplayState: Sendable {
    let clockSize: CGFloat
    let clockOriginX: CGFloat
    let clockOriginY: CGFloat

    init(
        screenWidth: CGFloat,
        screenHeight: CGFloat,
        sizePercent: Double,
        position: Position
    ) {
        let shortestDimension = min(screenWidth, screenHeight)
        self.clockSize = shortestDimension * sizePercent / 100.0
        self.clockOriginX = screenWidth * position.xPercent / 100.0
        self.clockOriginY = screenHeight * position.yPercent / 100.0
    }
}
