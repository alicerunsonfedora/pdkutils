//
//  Logging.swift
//  Renzo
//
//  Created by Marquis Kurt on 22-01-2026.
//

import PlaydateKit

/// A facility used to log events for a given subsystem. 
public struct OSLog {
    /// An enumeration of the logging levels available.
    public enum LogLevel {
        /// Display all messages, including debug messages.
        case debug

        /// Only display warnings and errors.
        case warningsAndErrors
    }

    /// Whether the timestamp should be displayed in logging messages.
    public var displaysTimestamp: Bool = true

    /// The level at which messages will be emitted to the console.
    public var logLevel: LogLevel = .warningsAndErrors

    /// The subsystem associated with this log.
    public let subsystem: String?

    var subsystemComponent: String {
        if let subsystem {
            "(sub: \(subsystem)) "
        } else {
            ""
        }
    }

    /// Create a logger for a given subsystem.
    /// - Parameter subsystem: The subsystem that the logger is associated with.
    public init(subsystem: String? = nil) {
        displaysTimestamp = true
        logLevel = .warningsAndErrors
        self.subsystem = subsystem
    }

    /// Log a debug message to the console.
    /// - Parameter message: The message to log.
    public func debug(_ message: String) {
        guard logLevel == .debug else {
            return
        }
        PDReportDebug(subsystemComponent + message, displaysTimestamp: displaysTimestamp)
    }

    /// Log a warning message to the console.
    /// - Parameter message: The message to log.
    public func warning(_ message: String) {
        PDReportWarning(subsystemComponent + message, displayTimestamp: displaysTimestamp)
    }

    /// Log an error message to the console.
    /// - Parameter message: The message to log.
    public func error(_ message: String) {
        PDReportError(subsystemComponent + message, displayTimestamp: displaysTimestamp)
    }

    /// Log a fatal error message to the console.
    /// - Parameter message: The message to log.
    public func fatal(_ message: String) {
        PDReportFatalError(subsystemComponent + message, displayTimestamp: displaysTimestamp)
    }
}

/// Quickly log a debug message to the console.
/// - Parameter message: The message to log.
/// - Parameter displaysTimestamp: Whether the timestamp should be displayed in the log message.
public func PDReportDebug(_ message: String, displaysTimestamp: Bool = true) {
    guard displaysTimestamp else {
        System.log("[DBG]: \(message)")
        return
    }
    let formattedString = RFGetCurrentFormattedDate()
    System.log("[DBG] (\(formattedString)): \(message)")
}

/// Quickly log a warning message to the console.
/// - Parameter message: The message to log.
/// - Parameter displayTimestamp: Whether the timestamp should be displayed in the log message.
public func PDReportWarning(_ message: String, displayTimestamp: Bool = true) {
    guard displayTimestamp else {
        System.log("[WARN]: \(message)")
        return
    }
    let formattedString = RFGetCurrentFormattedDate()
    System.log("[WARN] (\(formattedString)): \(message)")
}

/// Quickly log an error message to the console.
/// - Parameter message: The message to log.
/// - Parameter displayTimestamp: Whether the timestamp should be displayed in the log message.
public func PDReportError(_ message: String, displayTimestamp: Bool = true) {
    guard displayTimestamp else {
        System.log("[ERR]: \(message)")
        return
    }
    let formattedString = RFGetCurrentFormattedDate()
    System.log("[ERR] (\(formattedString)): \(message)")
}

/// Quickly log a fatal error message to the console.
/// - Parameter message: The message to log.
/// - Parameter displayTimestamp: Whether the timestamp should be displayed in the log message.
public func PDReportFatalError(_ message: String, displayTimestamp: Bool = true) {
    guard displayTimestamp else {
        System.error("[FATAL]: \(message)")
        return
    }
    let formattedString = RFGetCurrentFormattedDate()
    System.error("[FATAL] (\(formattedString)): \(message)")
}

func RFGetCurrentFormattedDate() -> String {
    let dateTime = Date.now
    let formatter = ISO8601DateFormatter()
    return formatter.string(from: dateTime)
}
