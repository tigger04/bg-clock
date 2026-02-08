# bg-clock

A native macOS analogue clock rendered directly on the desktop background, built with SwiftUI.

## Quickstart

```bash
make build        # Build release binary
make test         # Run tests
make install      # Install to ~/Applications
make run          # Build and launch
```

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 16+ / Swift 6.0+

## Installation

### From source

```bash
git clone https://github.com/tigger04/bg-clock.git
cd bg-clock
make install
```

### With Homebrew

```bash
brew tap tigger04/tap
brew install --cask bg-clock
```

### Launch at login

```bash
make launchd-install    # Install and load launch agent
make launchd-uninstall  # Remove launch agent
make launchd-restart    # Restart the launch agent
```

## Configuration

Create or edit `~/.config/bg-clock/config.json`. The clock watches this file for changes and reloads automatically.

All fields are optional; missing values fall back to defaults.

```json
{
  "position": {
    "xPercent": 35.0,
    "yPercent": 20.0
  },
  "sizePercent": 30.0,
  "disc": {
    "enabled": true,
    "sizePercent": 95.0,
    "color": "#1a1a2e80",
    "borderColor": "#ffffff20",
    "borderWidth": 1.0,
    "blur": 10.0
  },
  "hourHand": {
    "color": "#cccccccc",
    "width": 6.0,
    "lengthPercent": 58.0
  },
  "minuteHand": {
    "color": "#cccccccc",
    "width": 4.0,
    "lengthPercent": 80.0
  },
  "secondHand": {
    "color": "#ff4444cc",
    "width": 1.5,
    "lengthPercent": 100.0
  },
  "dateCenter": {
    "enabled": true,
    "fontSize": 44.0,
    "discSizePercent": 15.0
  },
  "dayOnMinute": {
    "enabled": true,
    "allCaps": true,
    "fontSize": 16.0,
    "offsetPercent": 60.0
  },
  "monthOnHour": {
    "enabled": true,
    "allCaps": true,
    "fontSize": 20.0,
    "offsetPercent": 60.0
  }
}
```

### Colour values

Colours can be specified as:

- Hex strings: `"#RRGGBB"` or `"#RRGGBBAA"`
- RGBA objects: `{"r": 0.5, "g": 0.5, "b": 0.5, "a": 1.0}`

## Project structure

| Path | Purpose |
|------|---------|
| `Sources/BGClock/App/BGClockApp.swift` | Main entry point, hides from Dock |
| `Sources/BGClock/Window/DesktopWindowManager.swift` | Desktop-level transparent window |
| `Sources/BGClock/Configuration/ConfigLoader.swift` | JSON config with live file watching |
| `Sources/BGClock/Model/ClockConfiguration.swift` | All visual parameters as Codable structs |
| `Sources/BGClock/Model/ColorValue.swift` | Hex/RGBA colour decoding |
| `Sources/BGClock/Model/TimeState.swift` | Hand angles and date strings |
| `Sources/BGClock/Model/DisplayState.swift` | Screen-aware sizing and positioning |
| `Sources/BGClock/Views/ClockView.swift` | Top-level clock composition |
| `Sources/BGClock/Views/ClockFaceView.swift` | Disc, blur, tick markers |
| `Sources/BGClock/Views/ClockHandView.swift` | Reusable hand with optional overlay |
| `Sources/BGClock/Views/DateOverlayView.swift` | Centre date disc and hand labels |
| `Sources/BGClock/Views/DesktopClockRootView.swift` | Root view bridging config and layout |
| `Sources/BGClock/Views/VisualEffectBlur.swift` | NSVisualEffectView wrapper |
| `Makefile` | Build, test, install, release targets |
| `Resources/Info.plist` | App bundle metadata |
| `Resources/dev.tigger.bg-clock.plist` | launchd agent template |

## Documentation

- [Vision](docs/VISION.md) — project goals and design philosophy
- [Implementation plan](docs/implementation_plan.md) — phased build plan

## Uninstall

```bash
make uninstall  # Removes app and launch agent
```

To also remove configuration:

```bash
rm -rf ~/.config/bg-clock
```

## Licence

MIT. Copyright Tadg Paul.
