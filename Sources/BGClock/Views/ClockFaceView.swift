// ABOUTME: Renders the clock disc background and hour/minute markers.
// All sizes are proportional to the clock diameter from configuration.

import SwiftUI

struct ClockFaceView: View {
    let config: ClockConfiguration
    let clockSize: CGFloat

    var body: some View {
        ZStack {
            if config.backgroundBlur > 0 {
                Circle()
                    .fill(.clear)
                    .background(VisualEffectBlur())
                    .clipShape(Circle())
                    .frame(width: clockSize, height: clockSize)
            }

            DiscView(config: config.disc, clockSize: clockSize)

            MarkersView(
                majorConfig: config.majorMarker,
                minorConfig: config.minorMarker,
                clockSize: clockSize
            )
        }
        .frame(width: clockSize, height: clockSize)
    }
}

// MARK: - Disc

private struct DiscView: View {
    let config: DiscConfig
    let clockSize: CGFloat

    private var discSize: CGFloat {
        clockSize * config.sizePercent / 100.0
    }

    var body: some View {
        ZStack {
            if config.blur > 0 {
                Circle()
                    .fill(.clear)
                    .background(VisualEffectBlur())
                    .clipShape(Circle())
                    .frame(width: discSize, height: discSize)
            }

            Circle()
                .fill(config.color.color)
                .frame(width: discSize, height: discSize)
                .overlay(
                    Circle()
                        .stroke(
                            config.borderColor.color,
                            lineWidth: config.borderWidth
                        )
                )
                .shadow(color: .black.opacity(0.25), radius: 10)
        }
    }
}

// MARK: - Markers

private struct MarkersView: View {
    let majorConfig: MarkerConfig
    let minorConfig: MarkerConfig
    let clockSize: CGFloat

    var body: some View {
        ForEach(0..<60, id: \.self) { index in
            let isMajor = index % 5 == 0
            let mc = isMajor ? majorConfig : minorConfig
            let length = clockSize * mc.lengthPercent / 100.0
            let angle = Angle.degrees(Double(index) * 6.0)

            RoundedRectangle(cornerRadius: mc.width / 2)
                .fill(mc.color.color)
                .frame(width: length, height: mc.width)
                .offset(x: clockSize / 2 - length / 2)
                .rotationEffect(angle)
        }
    }
}
