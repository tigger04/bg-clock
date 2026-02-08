// ABOUTME: Root SwiftUI view for the desktop clock.
// Reads screen geometry and config to position and size the clock.

import SwiftUI

struct DesktopClockRootView: View {
    var configLoader: ConfigLoader

    var body: some View {
        GeometryReader { geometry in
            let display = DisplayState(
                screenWidth: geometry.size.width,
                screenHeight: geometry.size.height,
                sizePercent: configLoader.configuration.sizePercent,
                position: configLoader.configuration.position
            )

            ClockView(
                config: configLoader.configuration,
                clockSize: display.clockSize
            )
            .position(x: display.clockOriginX, y: display.clockOriginY)
        }
    }
}
