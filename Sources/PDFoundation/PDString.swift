//
//  PDString.swift
//  PDFoundation
//
//  Created by Marquis Kurt on 16-08-2026.
//

import PlaydateKit

/// A string wrapper that is available for manipulating UTF-8 strings more easily.
/// 
/// Due to certain limitations within embedded Swift, it is often necessary to compare the UTF-8 views of given strings
/// to perform specific operations such as equality checks or using strings as keys in a dictionary. The ``PDString``
/// structure is a lightweight wrapper around a standard Swift string that provides the appropriate conformances without
/// additional hassle.
public struct PDString: Sendable {
    package var string: String
    
    /// Initialize a string value.
    public init(_ string: String) {
        self.string = string
    }
}

extension PDString {
    public var utf8: String.UTF8View { string.utf8 }

    public static func + (lhs: PDString, rhs: PDString) -> PDString { PDString(lhs.string + rhs.string) }
    public static func + (lhs: PDString, rhs: String) -> PDString { PDString(lhs.string + rhs) }
    public static func + (lhs: String, rhs: PDString) -> PDString { PDString(lhs + rhs.string) }

    public mutating func append(_ other: PDString) { self.string.append(other.string) }
    public mutating func append(_ other: String) { self.string.append(other) }
    
    public static func += (lhs: inout Self, rhs: Self) { lhs = PDString(lhs.string + rhs.string) }
    public static func += (lhs: inout Self, rhs: String) { lhs = PDString(lhs.string + rhs) }

    /// Returns a copy of the string, removing the last character.
    ///
    /// If the string failed to drop the last character, it returns itself.
    public func droppingLastCharacter() -> PDString {
        return self.droppingLast(k: 1)
    }

    /// Returns a copy of the string, removing the last _k_ characters.
    ///
    /// If the string failed to drop the last character, it returns itself.
    /// - Parameter k: The number of characters to drop.
    public func droppingLast(k characters: Int) -> Self {
        if isEmpty { return self }
        let utf8View = self.string.utf8
        let substring = utf8View.dropLast(characters)
        guard let newSelf = String(substring) else { return self }
        return PDString(newSelf)
    }
}

extension PDString: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.string.utf8 == rhs.string.utf8 }
    public static func == (lhs: String, rhs: Self) -> Bool { lhs.utf8 == rhs.string.utf8 }
    public static func == (lhs: Self, rhs: String) -> Bool { lhs.string.utf8 == rhs.utf8 }
    
    public static func ~= (lhs: Self, rhs: Self) -> Bool { lhs.string.utf8 == rhs.string.utf8 }
    public static func ~= (lhs: String, rhs: Self) -> Bool { lhs.utf8 == rhs.string.utf8 }
    public static func ~= (lhs: Self, rhs: String) -> Bool { lhs.string.utf8 == rhs.utf8 }
    
    public func hasPrefix(_ prefix: PDString) -> Bool { self.string.hasPrefix(prefix.string) }
    public func hasPrefix(_ prefix: String) -> Bool { self.string.hasPrefix(prefix) }
    
    public func hasSuffix(_ suffix: PDString) -> Bool {
        guard suffix.string.utf8.count <= self.string.utf8.count else { return false }
        return self.string.utf8.dropFirst(self.string.utf8.count - suffix.string.utf8.count)
                .elementsEqual(suffix.string.utf8)
    }
    
    public func hasSuffix(_ suffix: String) -> Bool {
        guard suffix.utf8.count <= self.string.utf8.count else { return false }
        return self.string.utf8.dropFirst(self.string.utf8.count - suffix.utf8.count).elementsEqual(suffix.utf8)
    }
}

extension PDString: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(0xFF as UInt8)
        for element in self.string.utf8 {
            hasher.combine(element)
        }
    }
    
    public var hashValue: Int {
        var hasher = Hasher()
        hash(into: &hasher)
        return hasher.finalize()
    }
}

extension PDString: Collection {
    public typealias Element = String.Element
    public typealias Index = String.Index
    
    public var startIndex: Index { string.startIndex }
    public var endIndex: Index { string.endIndex }
    
    public func index(after index: Index) -> Index {
        string.index(after: index)
    }
    
    public subscript(position: Index) -> Element {
        string[position]
    }
}
extension PDString: Sequence {}

extension PDString: BidirectionalCollection {
    public func index(before index: Index) -> Index {
        string.index(before: index)
    }
}

extension PDString: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension PDString: ExpressibleByStringInterpolation {
    public init(stringInterpolation: DefaultStringInterpolation) {
        self.init(stringInterpolation.description)
    }
}

extension PDString: CustomStringConvertible {
    public var description: String { string }
}

public extension String {
    /// Initialize a string from a Playdate string value.
    init(pdString: PDString) {
        self = pdString.string
    }
}