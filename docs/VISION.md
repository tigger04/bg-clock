# bg-clock: Vision

<!-- Version: 0.2 | Last updated: 2026-02-07 -->

## Summary

bg-clock is a native macOS analogue clock that renders as a desktop background widget using SwiftUI. It is a lightweight, standalone application with no third-party dependencies.

## Motivation

A desktop analogue clock should be a simple, native drawing task — not something that requires a third-party widget runtime, a WebKit process, or a JavaScript/CoffeeScript toolchain. bg-clock is built from scratch in SwiftUI to be a proper macOS citizen: energy-efficient, display-aware, and trivially configurable.

## Goals

1. **Analogue clock features:**
   - Clock face with hour, minute, and second hands
   - Configurable hand colours, widths, and lengths (proportional to clock size)
   - Major and minor hour/minute markers
   - Translucent disc background with optional backdrop blur
   - Optional circular background blur area
   - Date display in the clock centre
   - Day of week on the minute hand
   - Month name on the hour hand
   - Smooth hand animation
   - Click-through (non-interactive with the desktop)
   - Proportional sizing based on screen dimensions

2. **Native macOS citizen:**
   - Runs as a background-only application (no Dock icon, no menu bar unless needed)
   - Renders at the desktop level (below all windows, above the wallpaper)
   - Responds to display changes (resolution, scaling, multi-monitor)
   - Respects system appearance (dark/light mode awareness)
   - Energy-efficient — minimal CPU when idle

3. **Configuration:**
   - All visual parameters configurable
   - Configuration via a file (JSON or YAML) — no recompilation needed to restyle
   - Sensible defaults

4. **Distribution:**
   - Installable via Homebrew (`brew install --cask bg-clock` or via our tap)
   - Launchable at login via launchd or Login Items
   - Single application bundle, no external dependencies

## Non-Goals

- Digital clock mode (this is an analogue clock)
- World clocks or multiple time zones
- Alarm, timer, or stopwatch features
- iOS/iPadOS/visionOS support (macOS only)
- Widget Gallery / WidgetKit integration (this is a standalone background app, not a macOS widget)

## Architecture (High Level)

```
bg-clock.app
├── SwiftUI Views
│   ├── ClockFaceView        — disc, blur, markers
│   ├── ClockHandView        — hour, minute, second hands
│   ├── DateOverlayView      — centre date, hand labels
│   └── DesktopHostView      — window management, click-through, desktop level
├── Model
│   ├── ClockConfiguration   — decoded from config file
│   └── TimeProvider         — current time, update cadence
├── Configuration
│   └── ConfigLoader         — reads/watches config file
└── App Lifecycle
    └── BGClockApp           — @main, background-only, no dock icon
```

### Desktop-Level Rendering

The application creates a borderless, transparent `NSWindow` set to `NSWindow.Level.init(rawValue: Int(CGWindowLevelForKey(.desktopWindow)) + 1)` — sitting just above the desktop but below all other windows. The window ignores mouse events (`ignoresMouseEvents = true`) to achieve click-through.

### Animation

SwiftUI's `TimelineView` with a `.animation` schedule drives hand rotation at an appropriate cadence (e.g. once per second for the second hand).

## Prior Art

- [SmoothAnalogClock.widget](https://github.com/ruurd/SmoothAnalogClock.widget) by ruurd — an analogue clock desktop widget that inspired this project's visual design

## Success Criteria

- Zero runtime dependencies
- CPU usage under 1% when idle on Apple Silicon
- Configurable without recompilation
- Installable via `make install` and Homebrew
