//
//  Logging.swift
//  Renzo
//
//  Created by Marquis Kurt on 22-01-2026.
//

import PlaydateKit

public struct OSLog {
    public enum LogLevel {
        case debug
        case warningsAndErrors
    }

    public var displaysTimestamp: Bool = true
    public var logLevel: LogLevel = .warningsAndErrors
    public let subsystem: String?

    var subsystemComponent: String {
        if let subsystem {
            "(sub: \(subsystem)) "
        } else {
            ""
        }
    }

    public init(subsystem: String? = nil) {
        displaysTimestamp = true
        logLevel = .warningsAndErrors
        self.subsystem = subsystem
    }

    public func debug(_ message: String) {
        guard logLevel == .debug else {
            return
        }
        PDReportDebug(subsystemComponent + message, displaysTimestamp: displaysTimestamp)
    }

    public func warning(_ message: String) {
        PDReportWarning(subsystemComponent + message, displayTimestamp: displaysTimestamp)
    }

    public func error(_ message: String) {
        PDReportError(subsystemComponent + message, displayTimestamp: displaysTimestamp)
    }

    public func fatal(_ message: String) {
        PDReportFatalError(subsystemComponent + message, displayTimestamp: displaysTimestamp)
    }
}

public func PDReportDebug(_ message: String, displaysTimestamp: Bool = true) {
    guard displaysTimestamp else {
        System.log("[DBG]: \(message)")
        return
    }
    let formattedString = RFGetCurrentFormattedDate()
    System.log("[DBG] (\(formattedString)): \(message)")
}

public func PDReportWarning(_ message: String, displayTimestamp: Bool = true) {
    guard displayTimestamp else {
        System.log("[WARN]: \(message)")
        return
    }
    let formattedString = RFGetCurrentFormattedDate()
    System.log("[WARN] (\(formattedString)): \(message)")
}

public func PDReportError(_ message: String, displayTimestamp: Bool = true) {
    guard displayTimestamp else {
        System.log("[ERR]: \(message)")
        return
    }
    let formattedString = RFGetCurrentFormattedDate()
    System.log("[ERR] (\(formattedString)): \(message)")
}

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
