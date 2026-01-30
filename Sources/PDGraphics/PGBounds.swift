//
//  PGBounds.swift
//  PDGraphics 
//
//  Created by Marquis Kurt on 29-12-2025.
//

import PlaydateKit

/// A structure representing the bounds of a rectangle.
public struct PGBounds {
    /// The minimum X value.
    public var minX: Int

    /// The minimum Y value.
    public var minY: Int

    /// The maximum X value.
    public var maxX: Int

    /// The maximum Y value.
    public var maxY: Int
}

/// Clips the specified rectangle such that it can be drawn within the bounds of the Playdate's screen.
/// - Parameter rect: The rectangle to clip to the display's bounds.
/// - Returns: The rectangle expressed as bounds inside the Playdate's screen.
public func PGClipRectToBounds(_ rect: Rect) -> PGBounds {
    var rectMinX = Int(max(0, rect.x))
    var rectMaxX = Int(rect.maxX)
    var rectMinY = Int(max(0, rect.y))
    var rectMaxY = Int(rect.maxY)

    if rectMinX > rectMaxX {
        (rectMinX, rectMaxX) = (rectMaxX, rectMinX)
    }
    if rectMaxX >= PGDisplayWidth {
        rectMaxX = PGDisplayWidth - 1
    }

    if rectMinY > rectMaxY {
        (rectMinY, rectMaxY) = (rectMaxY, rectMinY)
    }
    if rectMaxY >= PGDisplayHeight {
        rectMaxY = PGDisplayHeight - 1
    }

    return PGBounds(minX: rectMinX, minY: rectMinY, maxX: rectMaxX, maxY: rectMaxY)
}
