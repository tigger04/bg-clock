// ABOUTME: Loads ClockConfiguration from a JSON file and watches for changes.
// Falls back to defaults if no config file exists or if parsing fails.

import Foundation
import os

@MainActor
@Observable
final class ConfigLoader {
    private(set) var configuration: ClockConfiguration = .init()
    @ObservationIgnored private var fileWatcher: DispatchSourceFileSystemObject?
    @ObservationIgnored private var fileDescriptor: Int32 = -1

    private static let logger = Logger(
        subsystem: "dev.tigger.bg-clock",
        category: "ConfigLoader"
    )

    static let configDirectory: URL = {
        FileManager.default.homeDirectoryForCurrentUser
            .appending(path: ".config/bg-clock")
    }()

    static let configPath: URL = {
        configDirectory.appending(path: "config.json")
    }()

    init() {
        loadFromDisk()
        startWatching()
    }

    func loadFromDisk() {
        let path = Self.configPath.path(percentEncoded: false)

        guard FileManager.default.fileExists(atPath: path) else {
            Self.logger.info("No config file at \(path, privacy: .public); using defaults")
            configuration = .init()
            return
        }

        guard let data = FileManager.default.contents(atPath: path) else {
            Self.logger.warning("Cannot read config file at \(path, privacy: .public); using defaults")
            configuration = .init()
            return
        }

        do {
            let decoder = JSONDecoder()
            configuration = try decoder.decode(ClockConfiguration.self, from: data)
            Self.logger.info("Configuration loaded from \(path, privacy: .public)")
        } catch let error as DecodingError {
            Self.logger.warning("Invalid config JSON: \(error.localizedDescription, privacy: .public); using defaults")
            configuration = .init()
        } catch {
            Self.logger.warning("Config load error: \(error.localizedDescription, privacy: .public); using defaults")
            configuration = .init()
        }
    }

    /// Decode configuration from raw JSON data (used for testing).
    nonisolated static func decode(from data: Data) -> ClockConfiguration? {
        try? JSONDecoder().decode(ClockConfiguration.self, from: data)
    }

    private func startWatching() {
        let dirPath = Self.configDirectory.path(percentEncoded: false)

        // Ensure directory exists so we can watch it
        if !FileManager.default.fileExists(atPath: dirPath) {
            try? FileManager.default.createDirectory(
                atPath: dirPath,
                withIntermediateDirectories: true
            )
        }

        fileDescriptor = open(dirPath, O_EVTONLY)
        guard fileDescriptor >= 0 else {
            Self.logger.warning("Cannot open config directory for watching: \(dirPath, privacy: .public)")
            return
        }

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: .write,
            queue: .main
        )

        source.setEventHandler { [weak self] in
            self?.loadFromDisk()
        }

        source.setCancelHandler { [weak self] in
            guard let self else { return }
            if self.fileDescriptor >= 0 {
                close(self.fileDescriptor)
                self.fileDescriptor = -1
            }
        }

        source.resume()
        fileWatcher = source
    }

    private func stopWatching() {
        fileWatcher?.cancel()
        fileWatcher = nil
    }
}
