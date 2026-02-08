# bg-clock: Implementation Plan

<!-- Version: 0.1 | Last updated: 2026-02-07 -->

This plan breaks the project into phases. Each phase is a working milestone — the app should build and run (even if incomplete) at the end of every phase. We follow TDD throughout: tests first, then implementation.

## Toolchain

- **Swift 6.2** / **Xcode 26.2** (Apple Silicon)
- **Build system:** Swift Package Manager (SPM) — no `.xcodeproj`
- **macOS deployment target:** 14.0 (Sonoma) — gives us `TimelineView`, `Observable` macro, modern SwiftUI
- **Testing:** Swift Testing framework (`@Test`, `#expect`)
- **No third-party dependencies**

## Project Layout

```
bg-clock/
├── Package.swift
├── Makefile
├── Sources/
│   └── BGClock/
│       ├── App/
│       │   └── BGClockApp.swift          — @main entry point
│       ├── Window/
│       │   └── DesktopWindowManager.swift — NSWindow setup, desktop level, click-through
│       ├── Views/
│       │   ├── ClockView.swift            — top-level clock composition
│       │   ├── ClockFaceView.swift         — disc, blur, markers
│       │   ├── ClockHandView.swift         — single hand (reused for hr/min/sec)
│       │   └── DateOverlayView.swift       — centre date, day-on-minute, month-on-hour
│       ├── Model/
│       │   ├── ClockConfiguration.swift    — Codable config struct with defaults
│       │   └── TimeState.swift             — current time, angles, date strings
│       └── Configuration/
│           └── ConfigLoader.swift          — reads JSON config, watches for changes
├── Tests/
│   └── BGClockTests/
│       ├── ClockConfigurationTests.swift
│       ├── TimeStateTests.swift
│       ├── ConfigLoaderTests.swift
│       └── ClockHandAngleTests.swift
├── docs/
│   ├── VISION.md
│   └── implementation_plan.md
├── LICENSE
└── README.md
```

## Phases

---

### Phase 0: Project Skeleton

**Objective:** Empty SwiftUI app that builds, runs, shows a blank transparent window on the desktop, and hides from the Dock.

**Tasks:**

1. Create `Package.swift` — executable target `BGClock`, macOS 14.0+, Swift 6.2
2. Create `BGClockApp.swift` — `@main` App struct with empty `WindowGroup`
3. Set `LSUIElement = true` in Info.plist (or programmatically) to hide from Dock
4. Create `DesktopWindowManager.swift`:
   - Borderless, transparent `NSWindow`
   - Window level: desktop + 1
   - `ignoresMouseEvents = true`
   - Full-screen sized, positioned on main screen
5. Create `Makefile` with targets: `build`, `run`, `test`, `clean`, `install`
6. Verify: app launches, shows nothing visible, does not appear in Dock, quits cleanly

**Tests:**
- `DesktopWindowManager` can be instantiated (unit test for configuration values)

---

### Phase 1: Configuration Model

**Objective:** `ClockConfiguration` struct that decodes from JSON with sensible defaults.

**Tasks:**

1. Define `ClockConfiguration` as a `Codable` struct mirroring all visual parameters:
   - Position (x%, y% from screen edges)
   - Size (percentage of screen width)
   - Hand config (colour, width, length%) for hour, minute, second
   - Marker config (colour, width, length%) for major and minor
   - Disc config (size%, colour, border, blur)
   - Background blur radius
   - Date centre config (enabled, font, colour, size%)
   - Day-on-minute config (enabled, font, colour, offset%, caps, stretch, spacing)
   - Month-on-hour config (enabled, font, colour, offset%, caps, stretch, spacing)
2. Provide `static let defaultConfig` with values matching the original clock's aesthetic
3. Create `ConfigLoader`:
   - Reads from `~/.config/bg-clock/config.json` (XDG-ish path)
   - Falls back to bundled defaults if no file exists
   - Uses `DispatchSource.makeFileSystemObjectSource` to watch for changes and reload

**Tests:**
- Decode a complete JSON config
- Decode a partial JSON config (missing fields use defaults)
- Decode an empty JSON object (all defaults)
- Reject invalid JSON gracefully (fall back to defaults, log warning)
- Colour string parsing (hex, rgba)

---

### Phase 2: Time Model

**Objective:** `TimeState` that computes hand angles and date strings from the current time.

**Tasks:**

1. Define `TimeState`:
   - `hourAngle: Angle` — continuous, accounts for minutes (not just snapping to hours)
   - `minuteAngle: Angle` — continuous, accounts for seconds
   - `secondAngle: Angle` — continuous
   - `dateString: String` — day of month (e.g. "7")
   - `dayOfWeekString: String` — e.g. "SATURDAY"
   - `monthString: String` — e.g. "FEBRUARY"
2. `TimeState.now()` factory method
3. Angles are computed as: 12 o'clock = 0 degrees, clockwise positive

**Tests:**
- Midnight → all hands at 0 (12 o'clock position)
- 3:00:00 → hour at 90, minute at 0, second at 0
- 6:30:00 → hour at 195 (180 + 15 for the half-hour offset), minute at 180
- 12:00:00 → hour wraps back to 0 (360)
- Date strings correct for known dates
- Day/month capitalisation respects config

---

### Phase 3: Clock Face — Disc and Markers

**Objective:** Render the clock face background and hour/minute markers.

**Tasks:**

1. `ClockFaceView`:
   - Circular disc with configurable colour, size, border, shadow
   - Backdrop blur via `.background(.ultraThinMaterial)` or `VisualEffectView` wrapper
   - Optional outer background blur circle
2. Marker rendering:
   - 12 major markers (at hour positions) — configurable colour, width, length
   - 48 minor markers (at remaining minute positions)
   - Markers rendered as small rectangles rotated around the clock edge
3. All sizes proportional to the clock's diameter (derived from screen width %)

**Tests:**
- Marker count: 12 major + 48 minor = 60 total
- Marker rotation angles: major at 0, 30, 60... 330; minor at 6, 12, 18... (excluding multiples of 30)

---

### Phase 4: Clock Hands

**Objective:** Render hour, minute, second hands with smooth animation.

**Tasks:**

1. `ClockHandView` — a reusable view parameterised by:
   - Length (% of clock radius)
   - Width
   - Colour
   - Current angle
   - Optional child overlay (for day/month labels — Phase 5)
2. Hands rotate from the clock centre
3. Rounded end caps (matching the original's `border-radius` style)
4. Subtle drop shadow on each hand
5. Animation via `TimelineView(.animation)`:
   - Update `TimeState` each frame
   - SwiftUI implicit animation on `.rotationEffect` for smooth sweeping

**Tests:**
- Hand view accepts angle and renders (snapshot test or geometry validation)
- Hand length scales correctly with clock size

---

### Phase 5: Date Overlays

**Objective:** Render date in centre, day of week on minute hand, month on hour hand.

**Tasks:**

1. `DateOverlayView` — centre disc showing numeric date:
   - Circular background, configurable colour/blur/border
   - Text with configurable font, size, colour, shadow, stroke
   - Positioned at clock centre, above hands (z-order)
2. Day-on-minute label:
   - Text positioned along the minute hand at configurable offset %
   - Rotates with the minute hand
   - Counter-rotated so text remains readable (or rotates with hand — match original behaviour)
   - Configurable: caps, stretch, letter spacing, font, colour, shadow
3. Month-on-hour label:
   - Same approach as day-on-minute, but on the hour hand

**Tests:**
- Date overlay disabled when `config.dateCenter.enabled == false`
- Day string capitalisation when `allCaps == true` vs `false`
- Label offset positions correctly along hand length

---

### Phase 6: Display Awareness

**Objective:** Handle screen changes, multi-monitor, and system appearance.

**Tasks:**

1. Listen for `NSApplication.didChangeScreenParametersNotification`:
   - Resize/reposition window when resolution or screen arrangement changes
2. Position clock on the main screen (or configurable screen index)
3. Recalculate proportional sizes on screen change
4. Dark/light mode: if desired, adjust default colours (or leave to config)

**Tests:**
- Window resizes when screen parameters change (integration test with mock notification)
- Clock repositions to configured percentage coordinates

---

### Phase 7: Build, Install, Distribute

**Objective:** Makefile, Homebrew formula, launch-at-login.

**Tasks:**

1. `Makefile` targets:
   - `build` — `swift build -c release`
   - `test` — `swift test`
   - `run` — build and launch
   - `install` — copy `.app` bundle to `/Applications` or `~/Applications`
   - `uninstall` — remove app and config
   - `release` — bump version, tag, build, update Homebrew formula
   - `sync` — git add, commit, pull, push
   - `clean` — `swift package clean`
2. App bundle creation:
   - Script or Makefile logic to assemble `.app` from SPM executable + Info.plist
   - Info.plist: `LSUIElement = true`, bundle identifier, version
3. Homebrew cask formula in the tap repo
4. Optional: launchd plist for launch-at-login (`~/Library/LaunchAgents/`)
5. `README.md` with quickstart, installation, configuration reference

**Tests:**
- `make build` succeeds
- `make test` passes
- Built binary launches and exits cleanly

---

## Phase Dependency Graph

```
Phase 0 (skeleton)
  ├── Phase 1 (config)
  │     └── Phase 2 (time model)
  │           ├── Phase 3 (face/markers)
  │           ├── Phase 4 (hands)
  │           │     └── Phase 5 (date overlays)
  │           └── Phase 6 (display awareness)
  └── Phase 7 (build/distribute) — can begin in parallel after Phase 0
```

## Open Questions

1. **Config file format:** JSON is simplest (no dependencies). YAML would require a library or manual parsing. Recommendation: JSON.
2. **SPM app bundle:** SPM doesn't natively produce `.app` bundles. We'll need a small script to assemble the bundle structure (executable + Info.plist + resources). Alternatively, use `xcodebuild` with a generated `.xcodeproj` — but that's heavier.
3. **Second hand cadence:** Smooth sweep (update every frame) or tick-per-second? The original used 30-second CSS transitions. Recommendation: smooth sweep via `TimelineView(.animation)`, with a config option to disable the second hand entirely for lower CPU.
4. **Hand label readability:** Should day/month labels counter-rotate to stay upright, or rotate with the hand? The original rotates with the hand. Recommendation: match original, add config toggle later if needed.
