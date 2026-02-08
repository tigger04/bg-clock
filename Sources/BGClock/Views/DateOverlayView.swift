// ABOUTME: Renders date overlays: centre date disc and hand-mounted labels.
// DateCenterView shows the day number; HandLabelView shows day/month on hands.

import SwiftUI

/// Circular disc at the clock centre showing the numeric date.
struct DateCenterView: View {
    let config: DateCenterConfig
    let clockSize: CGFloat
    let dateString: String

    private var discSize: CGFloat {
        clockSize * config.discSizePercent / 100.0
    }

    var body: some View {
        if config.enabled {
            ZStack {
                if config.blur > 0 {
                    Circle()
                        .fill(.clear)
                        .background(VisualEffectBlur())
                        .clipShape(Circle())
                        .frame(width: discSize, height: discSize)
                }

                Circle()
                    .fill(config.backgroundColor.color)
                    .frame(width: discSize, height: discSize)
                    .overlay(
                        Circle()
                            .stroke(
                                config.borderColor.color,
                                lineWidth: config.borderWidth
                            )
                    )

                Text(dateString)
                    .font(.system(
                        size: config.fontSize,
                        weight: .fromNumeric(config.fontWeight)
                    ))
                    .monospacedDigit()
                    .foregroundStyle(config.color.color)
            }
            .frame(width: discSize, height: discSize)
        }
    }
}

/// Text label positioned along a clock hand (day-of-week or month).
struct HandLabelView: View {
    let text: String
    let config: HandLabelConfig
    let handLength: CGFloat

    private var displayText: String {
        config.allCaps ? text.uppercased() : text.capitalized
    }

    private var offset: CGFloat {
        handLength * config.offsetPercent / 100.0
    }

    var body: some View {
        if config.enabled {
            Text(displayText)
                .font(.system(
                    size: config.fontSize,
                    weight: .fromNumeric(config.fontWeight)
                ))
                .tracking(config.letterSpacing)
                .foregroundStyle(config.color.color)
                .scaleEffect(x: config.stretchFactor, y: 1.0)
                .padding(config.padding)
                .background(
                    RoundedRectangle(cornerRadius: config.borderRadius)
                        .fill(config.backgroundColor.color)
                )
                .offset(x: offset)
        }
    }
}
