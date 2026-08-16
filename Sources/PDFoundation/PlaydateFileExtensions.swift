//
//  PlaydateFileExtensions.swift
//  Renzo
//
//  Created by Marquis Kurt on 27-01-2026.
//

import PlaydateKit

/// A typealias pointing to a Playdate file handle.
public typealias PDFile = File.FileHandle

extension PDFile {
    @discardableResult
    fileprivate func readOrSilentlyFail<T>(buffer: UnsafeMutablePointer<T>, length: CUnsignedInt) -> Int {
        do {
            return try self.read(buffer: buffer, length: length)
        } catch {
            PDReportError("Failed to read bytes as type '\(T.self)': \(error.description).")
            return -1
        }
    }
}

extension File {
    /// Returns whether a file exists at the specified path and has a non-zero amount of bytes.
    /// - Parameter path: The path containing the file to validate.
    public static func fileExists(at path: String) -> Bool {
        do {
            let stat = try File.stat(path: path)
            return stat.size > 0
        } catch {
            return false
        }
    }
    
    public static func fileExists(at path: PDString) -> Bool {
        self.fileExists(at: path.string)
    }
}

extension PDFile {
    /// Reads the next set of bytes and casts it to the specified type.
    /// - Parameter decodedType: The type to cast the bytes into.
    /// - Parameter value: The value to write the data into.
    public func read<T>(as decodedType: T.Type, into value: inout T) {
        withUnsafeMutablePointer(to: &value) { ptr in
            _ = self.readOrSilentlyFail(buffer: ptr, length: UInt32(MemoryLayout<T>.size))
        }
    }

    /// Reads the next specified number of bytes as a String.
    /// - Parameter bytes: The number of bytes to interpret as a string.
    public func readString(ofLength bytes: Int) -> String {
        let strPointer = UnsafeMutableRawPointer.allocate(
            byteCount: bytes, alignment: MemoryLayout<CChar>.alignment)
        do {
            _ = try self.read(buffer: strPointer, length: UInt32(bytes))
        } catch {
            return ""
        }
        let buffer = UnsafeBufferPointer<UInt8>(
            start: strPointer.assumingMemoryBound(to: UInt8.self), count: bytes)
        return String(decoding: buffer, as: Unicode.UTF8.self)
    }

    /// Reads the next specified number of bytes as a PDString.
    /// - Parameter bytes: The number of bytes to interpret as a string.
    public func readString(ofLength bytes: Int) -> PDString {
        PDString(readString(ofLength: bytes))
    }

    /// Write the specified string into the given file.
    /// - Parameter string: The string to write into the file.
    /// - Returns: The number of bytes written into the file, or -1 if the operation failed.
    @discardableResult
    public func writeString(_ string: String) -> Int {
        return string.withCString { ptr in
            let buffer = UnsafeRawBufferPointer(start: ptr, count: string.utf8.count)
            return (try? write(buffer: buffer)) ?? -1
        }
    }

    /// Write the specified string into the given file.
    /// - Parameter string: The string to write into the file.
    /// - Returns: The number of bytes written into the file, or -1 if the operation failed.
    @discardableResult
    public func writeString(_ string: PDString) -> Int {
        return writeString(string.string)
    }
}

extension PDString {
    /// Initialize a string by reading data from a file as UTF-8.
    /// - Parameter file: The file to read the string contents from.
    /// - Parameter length: The number of bytes to read as a string.
    public init(reading file: PDFile, ofLength length: Int) {
        self = file.readString(ofLength: length)
    }

    /// Initialize a string by reading an entire file as a UTF-8 string.
    /// - Parameter filePath: The path to the file to read.
    public init(contentsOf filePath: PDString) throws(Playdate.Error) {
        let fileStats = try File.stat(path: filePath.string)
        let file = try File.open(path: filePath.string, mode: .read)
        self.init(reading: file, ofLength: Int(fileStats.size))
        try file.close()
    }

    /// Writes the current string into a file at the specified path.
    /// - Parameter path: The path to write the file to.
    public func write(to path: PDString) throws(Playdate.Error) {
        let file = try File.open(path: path.string, mode: .write)
        file.writeString(self)
        try file.close()
    }
}

extension String {
    /// Initialize a string by reading data from a file as UTF-8.
    /// - Parameter file: The file to read the string contents from.
    /// - Parameter length: The number of bytes to read as a string.
    public init(reading file: PDFile, ofLength length: Int) {
        self = file.readString(ofLength: length)
    }

    /// Initialize a string by reading an entire file as a UTF-8 string.
    /// - Parameter filePath: The path to the file to read.
    public init(contentsOf filePath: String) throws(Playdate.Error) {
        let fileStats = try File.stat(path: filePath)
        let file = try File.open(path: filePath, mode: .read)
        self.init(reading: file, ofLength: Int(fileStats.size))
        try file.close()
    }

    /// Writes the current string into a file at the specified path.
    /// - Parameter path: The path to write the file to.
    public func write(to path: String) throws(Playdate.Error) {
        let file = try File.open(path: path, mode: .write)
        file.writeString(self)
        try file.close()
    }
}

extension Character {
    /// Initialize a character by reading data from a file as UTF-8.
    /// - Parameter file: The file to read the character from.
    public init?(reading file: PDFile) {
        let text: String = file.readString(ofLength: 1)
        guard let char = text.first else { return nil }
        self = char
    }
}

extension FixedWidthInteger {
    /// Initialize an integer value by reading data from a file.
    /// - Parameter file: The file to read the integer value from.
    public init(reading file: PDFile) {
        self = .min
        file.read(as: Self.self, into: &self)
    }
}

extension FloatingPoint {
    /// Initialize a floating point value by reading data from a file.
    /// - Parameter file: The file to read the floating point value from.
    public init(reading file: PDFile) {
        self = .nan
        file.read(as: Self.self, into: &self)
    }
}

extension Bool {
    /// Initialize a boolean value by reading data from a file.
    /// - Parameter file: THe file to read the floating point value from.
    public init(reading file: PDFile) {
        self = false
        file.read(as: Bool.self, into: &self)
    }
}
