//
//  StringExtensions.swift
//  PDFoundation
//
//  Created by Marquis Kurt on 22-01-2026.
//

// NOTE(marquiskurt): These are only here because some collection API-specific content doesn't quite work under
// Embedded Swift for varying reasons. So, we need to redirect the content to use the UTF-8 view instead of the raw
// content.

extension String {
    /// Whether the string has no content.
    public var isEmpty: Bool { utf8.isEmpty }

    /// Whether the string has any content.
    public var isNotEmpty: Bool { !isEmpty }

    public func equals(_ other: String) -> Bool {
        return self.utf8.elementsEqual(other.utf8)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.utf8.elementsEqual(rhs.utf8)
    }

    public static func ~= (lhs: Self, rhs: Self) -> Bool {
        lhs == rhs
    }

    public func hasPrefix(_ prefix: Self) -> Bool {
        self.utf8.starts(with: prefix.utf8)
    }

    public func hasSuffix(_ suffix: Self) -> Bool {
        guard suffix.utf8.count <= self.utf8.count else { return false }
        return self.utf8.dropFirst(self.utf8.count - suffix.utf8.count).elementsEqual(suffix.utf8)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(0xFF as UInt8)
        for element in self.utf8 {
            hasher.combine(element)
        }
    }

    public var hashValue: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }

    /// Returns a copy of the string, removing the last character.
    ///
    /// If the string failed to drop the last character, it returns itself.
    public func droppingLastCharacter() -> Self {
        return self.droppingLast(k: 1)
    }

    /// Returns a copy of the string, removing the last _k_ characters.
    ///
    /// If the string failed to drop the last character, it returns itself.
    /// - Parameter k: The number of characters to drop.
    public func droppingLast(k characters: Int) -> Self {
        if isEmpty { return self }
        let utf8View = self.utf8
        let substring = utf8View.dropLast(characters)
        guard let newSelf = String(substring) else { return self }
        return newSelf
    }
}

extension String.UTF8View: @retroactive Equatable, @retroactive Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.elementsEqual(rhs)
    }
    public static func == (lhs: String, rhs: Self) -> Bool { lhs.utf8 == rhs }
    public static func == (lhs: Self, rhs: String) -> Bool { lhs == rhs.utf8 }
    
    public static func ~= (lhs: Self, rhs: Self) -> Bool { lhs == rhs }
    public static func ~= (lhs: String, rhs: Self) -> Bool { lhs.utf8 == rhs }
    public static func ~= (lhs: Self, rhs: String) -> Bool { lhs == rhs.utf8 }
    
    public func hasPrefix(_ prefix: Self) -> Bool { self.starts(with: prefix) }
    public func hasPrefix(_ prefix: String) -> Bool { self.starts(with: prefix.utf8) }
    
    public func hasSuffix(_ suffix: Self) -> Bool {
        guard suffix.count <= self.count else { return false }
        return self.dropFirst(self.count - suffix.count).elementsEqual(suffix)
    }
    public func hasSuffix(_ suffix: String) -> Bool { hasSuffix(suffix.utf8) }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(0xFF as UInt8)
        for element in self {
            hasher.combine(element)
        }
    }
    
    public var hashValue: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

public extension Array where Element == String {
    func firstIndex(of value: String) -> Index? {
        self.firstIndex { $0.equals(value) }
    }
}
