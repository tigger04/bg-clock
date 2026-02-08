// ABOUTME: Swift Package Manager manifest for bg-clock.
// Defines the executable target and test target for the native macOS analogue clock app.

// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "bg-clock",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "BGClock",
            path: "Sources/BGClock"
        ),
        .testTarget(
            name: "BGClockTests",
            dependencies: ["BGClock"],
            path: "Tests/BGClockTests"
        ),
    ]
)
