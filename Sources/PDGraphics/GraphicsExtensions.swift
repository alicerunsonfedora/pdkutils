//
//  GraphicsExtensions.swift
//  PDKUtils
//
//  Created by Marquis Kurt on 01-02-2026.
//

import PlaydateKit

/// A pattern bitmask that indicates the pattern should always be drawn.
public let PGPatternMaskAlwaysDraw: BitPattern = (255, 255, 255, 255, 255, 255, 255, 255)

/// A pattern bitmask that indicates the pattern should never be drawn.
public let PGPatternMaskNeverDraw: BitPattern = (0, 0, 0, 0, 0, 0, 0, 0)

let bayerPattern: [[UInt8]] = [
    [0, 32, 8, 40, 2, 34, 10, 42],
    [48, 16, 56, 24, 50, 18, 58, 26],
    [12, 44, 4, 36, 14, 46, 6, 38],
    [60, 28, 52, 20, 62, 30, 54, 22],
    [3, 35, 11, 43, 1, 33, 9, 41],
    [51, 19, 59, 27, 49, 17, 57, 25],
    [15, 47, 7, 39, 13, 45, 5, 37],
    [63, 31, 55, 23, 61, 29, 53, 21],
]

public extension PGColor {
    /// Generates a bayer pattern based on the proposed lightness value.
    /// - Parameter lightness: The lightness value.
    static func dithered(by lightness: Float) -> Self {
        var pattern: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        let threshold = UInt8((1 - lightness) * 64)
        for row in 0..<8 {
            for col in 0..<8 {
                PGApplyBayerPattern(&pattern, row: row, col: col, threshold: threshold)
            }
        }
        return .pattern(
            (pattern[0], pattern[1], pattern[2], pattern[3], pattern[4], pattern[5], pattern[6], pattern[7]),
            mask: PGPatternMaskAlwaysDraw
        )
    }
}

func PGApplyBayerPattern(_ pattern: inout [UInt8], row: Int, col: Int, threshold: UInt8) {
    if bayerPattern[row][col] >= threshold {
        pattern[row] |= (1 << col)
    } else {
        pattern[row] &= ~(1 << col)
    }
}
