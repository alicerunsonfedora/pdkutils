//
//  PGTriangle.swift
//  Renzo
//
//  Created by Marquis Kurt on 29-12-2025.
//

import PlaydateKit
import PDFoundation

/// A representation of a triangular face in two-dimensional space.
public struct PGTriangle: Equatable {
    /// The first point of the face.
    public var pointA: Point

    /// The second point of the face.
    public var pointB: Point

    /// The third point of the face.
    public var pointC: Point

    public init(a pointA: Point, b pointB: Point, c pointC: Point) {
        self.pointA = pointA
        self.pointB = pointB
        self.pointC = pointC
    }
}

extension PGTriangle {
    /// The face's signed area.
    ///
    /// The signed area is typically used to determine its winding order so that 3D renderers can cull faces
    /// that shouldn't be rendered.
    public var signedArea: Float {
        (pointB.x - pointA.x) * (pointC.y - pointB.y) - (pointC.x - pointB.x)
            * (pointB.y - pointA.y)
    }
}

/// Sorts a triangle by its Y index.
func PGSortTriangle(_ tri: PGTriangle) -> PGTriangle {
    var sortedTri = PGTriangle(a: tri.pointA, b: tri.pointB, c: tri.pointC)
    if sortedTri.pointB.y < sortedTri.pointA.y {
        (sortedTri.pointA, sortedTri.pointB) = (sortedTri.pointB, sortedTri.pointA)
    }
    if sortedTri.pointC.y < sortedTri.pointB.y {
        (sortedTri.pointB, sortedTri.pointC) = (sortedTri.pointC, sortedTri.pointB)
    }
    if sortedTri.pointB.y < sortedTri.pointA.y {
        (sortedTri.pointA, sortedTri.pointB) = (sortedTri.pointB, sortedTri.pointA)
    }

    return sortedTri
}

/// Floors the X and Y components of a triangle.
func PGFloorTriangle(_ tri: inout PGTriangle) {
    tri.pointA.x = floorf(tri.pointA.x)
    tri.pointB.x = floorf(tri.pointB.x)
    tri.pointC.x = floorf(tri.pointC.x)

    tri.pointA.y = floorf(tri.pointA.y)
    tri.pointB.y = floorf(tri.pointB.y)
    tri.pointC.y = floorf(tri.pointC.y)
}

/// Validates that a triangle can be drawn on the screen.
///
/// > Important: This function assumes the triangle is already sorted.
func PGTriangleIsDrawable(_ tri: PGTriangle) -> Bool {
    if tri.pointA.y == tri.pointC.y { return false }
    if tri.pointA.x == tri.pointB.x, tri.pointB.x == tri.pointC.x { return false }
    if tri.pointA.y >= PGDisplayHeightF || tri.pointC.y < 0 { return false }
    if tri.pointA.x < 0, tri.pointB.x < 0, tri.pointC.x < 0 { return false }

    if tri.pointA.x >= PGDisplayWidthF, tri.pointB.x >= PGDisplayWidthF, tri.pointC.x >= PGDisplayWidthF {
        return false
    }
    return true
}

/// Fills a triangle with a given color.
/// - Parameter tri: The triangle defining the region of the screen to fill with a color.
/// - Parameter color: The color to fill the region with.
public func PGFillTriangle(_ tri: PGTriangle, color: PGColor = .black) {
    guard var frameBuffer = Graphics.getFrame() else {
        PDReportError("Failed to get frame buffer.")
        return
    }
    PGFillTriangle(tri, color: color, into: &frameBuffer)
}

/// Fills a triangle with a given color.
/// - Parameter tri: The triangle defining the region of the screen to fill with a color.
/// - Parameter color: The color to fill the region with.
/// - Parameter frameBuffer: The frame buffer to draw the triangle into.
public func PGFillTriangle(_ tri: PGTriangle, color: PGColor = .black, into frameBuffer: inout PGBuffer) {
    if case .solid(.clear) = color {
        return
    }
    var sortedTri = PGSortTriangle(tri)
    PGFloorTriangle(&sortedTri)

    guard PGTriangleIsDrawable(sortedTri) else { return }

    if sortedTri.pointB.y == sortedTri.pointC.y {
        PGFillBottomFlatTriangle(sortedTri, color: color, into: &frameBuffer)
        return
    }
    if sortedTri.pointA.y == sortedTri.pointB.y {
        PGFillTopFlatTriangle(sortedTri, color: color, into: &frameBuffer)
        return
    }

    let deltaY = (sortedTri.pointB.y - sortedTri.pointA.y) / (sortedTri.pointC.y - sortedTri.pointA.y)
    let deltaX = sortedTri.pointC.x - sortedTri.pointA.x
    let cutter = Point(x: sortedTri.pointA.x + deltaY * deltaX, y: sortedTri.pointB.y)

    let top = PGTriangle(a: sortedTri.pointB, b: cutter, c: sortedTri.pointC)
    let bottom = PGTriangle(a: sortedTri.pointA, b: sortedTri.pointB, c: cutter)

    PGFillTopFlatTriangle(top, color: color, into: &frameBuffer)
    PGFillBottomFlatTriangle(bottom, color: color, into: &frameBuffer)
}

/// Fills a triangle with a flat bottom a given color.
/// - Parameter tri: The triangle that will be filled on the screen.
/// - Parameter color: The color to fill the triangle with.
/// - Parameter frameBuffer: The frame buffer the triangle will be filled into.
func PGFillBottomFlatTriangle(_ tri: PGTriangle, color: PGColor = .black, into frameBuffer: inout PGBuffer) {
    let top = tri.pointA
    var left = tri.pointB
    var right = tri.pointC

    if left.x > right.x {
        (left.x, right.x) = (right.x, left.x)
    }

    let invertSlopeA = (left.x - top.x) / (left.y - top.y)
    let invertSlopeB = (right.x - top.x) / (right.y - top.y)

    var currentX_1 = top.x
    var currentX_2 = top.x

    for scanlineY in Int(top.y)...Int(left.y) {
        if (0..<PGDisplayHeight).contains(scanlineY) {
            PGDrawTriScanline(x1: currentX_1, x2: currentX_2, scanlineY: scanlineY, color: color, into: &frameBuffer)
        }
        currentX_1 += invertSlopeA
        currentX_2 += invertSlopeB
    }
}

/// Fills a triangle with a flat top a given color.
/// - Parameter tri: The triangle that will be filled on the screen.
/// - Parameter color: The color to fill the triangle with.
/// - Parameter frameBuffer: The frame buffer the triangle will be filled into.
func PGFillTopFlatTriangle(_ tri: PGTriangle, color: PGColor = .black, into frameBuffer: inout PGBuffer) {
    let bottom = tri.pointC
    var left = tri.pointA
    var right = tri.pointB

    if left.x > right.x {
        (left.x, right.x) = (right.x, left.x)
    }

    let invertSlopeA = (bottom.x - left.x) / (bottom.y - left.y)
    let invertSlopeB = (bottom.x - right.x) / (bottom.y - right.y)

    var currentX_1 = bottom.x
    var currentX_2 = bottom.x

    for scanlineY in stride(from: Int(bottom.y), to: Int(left.y) - 1, by: -1) {
        if (0..<PGDisplayHeight).contains(scanlineY) {
            PGDrawTriScanline(x1: currentX_1, x2: currentX_2, scanlineY: scanlineY, color: color, into: &frameBuffer)
        }
        currentX_1 -= invertSlopeA
        currentX_2 -= invertSlopeB
    }
}

func PGDrawTriScanline(x1: Float, x2: Float, scanlineY: Int, color: PGColor, into frameBuffer: inout PGBuffer) {
    var (currentX_1, currentX_2) = (x1, x2)
    if currentX_1 > currentX_2 {
        (currentX_1, currentX_2) = (currentX_2, currentX_1)
    }
    if currentX_2 < 0 || Int(currentX_1) >= PGDisplayWidth {
        return
    }
    PGDrawScanline(Int(currentX_1), Int(currentX_2), y: scanlineY, color: color, into: &frameBuffer)
}
