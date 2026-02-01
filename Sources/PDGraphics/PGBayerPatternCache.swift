//
//  PGBayerPatternCache.swift
//  PDKUtils
//
//  Created by Marquis Kurt on 01-02-2026.
//

import PlaydateKit
import PDFoundation

/// A read-only cache for Bayer patterns of varying brightness levels.
///
/// The cache provides fast access to common Bayer patterns based off brightness levels from 0-255, where 0 indicates
/// no brightness, and 255 indicates full brightness. This can be used in conjunction with
/// ``PlaydateKit/Graphics/Color/dithered(by:)`` to quickly provide patterns without recomputing them.
public struct PGBayerPatternCache {
    private let patterns: [BitPattern]

    /// Initialize the pattern cache.
    public init() {
        var patterns = [BitPattern]()
        for value in 0...255 {
            let lightValue = Float(value) / 255.0
            let brightness = PGColor.dithered(by: lightValue)
            guard case let .pattern(pattern, _) = brightness else {
                PDReportFatalError("The resulting color isn't a color pattern.")
                self.patterns = []
                return
            }
            patterns.append(pattern)
        }
        self.patterns = patterns
    }
}

extension PGBayerPatternCache: Collection {
    public typealias Element = PGColor
    public typealias Index = Array<BitPattern>.Index

    public var startIndex: Index { patterns.startIndex }
    public var endIndex: Index { patterns.endIndex }

    public func index(after i: Index) -> Index {
        patterns.index(after: i)
    }

    public subscript(position: Index) -> PGColor {
        let pattern = patterns[position]
        return .pattern(pattern, mask: PGPatternMaskAlwaysDraw)
    }

    /// Retrieve the Bayer pattern that matches the nearest brightness level.
    ///
    /// This subscript can be used in a similar manner to ``PlaydateKit/Graphics/Color/dithered(by:)``. Float values
    /// from 0-1 will be mapped to the appropriate index values.
    ///
    /// ```swift
    /// let cache = PGBayerPatternCache()
    ///
    /// let color = cache[0.5] // Equivalent to PGColor.dithered(by: 0.5)
    /// ```
    ///
    /// - Parameter nearestBrightness: The nearest brightness level to match against.
    public subscript(nearestBrightness: Float) -> PGColor {
        var brightness = nearestBrightness * 255
        brightness.round(.toNearestOrAwayFromZero)
        brightness = Swift.max(0, brightness)
        brightness = Swift.min(brightness, 255)
        return self[Int(brightness)]
    }
}

