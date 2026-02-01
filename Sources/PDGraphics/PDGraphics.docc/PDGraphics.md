# ``PDGraphics``

Display basic graphics primitives on your Playdate performantly.

## Overview

In most cases, the default APIs for drawing graphics primitives in
PlaydateKit suffice. However, for more performance-critical applications
and games such as 3D engines, PDGraphics can be used instead to draw
graphics primitives more performantly.

### XOR Support

By default, PDGraphics and PDKUtils has XOR support enabled. This allows
the usage of the `.xor` color option in the PDGraphics APIs. However, such
capabilties often cause extra overhead that may be unnecessary if your app
or game doesn't make use of this color type.

You can disable XOR support by passing in an appropriate set of traits
without `PDGraphicsXOR`:

```swift
dependencies: [
    .package(url: "https://source.marquiskurt.net/PDUniverse/pdkutils",
             branch: "main",
             traits: [])
]
```

When `PDGraphicsXOR` is disabled, all colors are assumed to be copy-only
and will skip additional checks for XOR.

## Topics

### Working with the frame buffer

- ``PGBuffer``
- ``PGDrawScanline(_:_:y:color:into:)``

### Colors and patterns

- ``PGColor``
- ``BitPattern``
- ``PGBayerPatternCache``
- ``PGPatternMaskAlwaysDraw``
- ``PGPatternMaskNeverDraw``

### Shapes

- ``PGBounds``
- ``PGTriangle``

### Displaying rectangles

- ``PGFillRect(_:color:)``
- ``PGFillRect(_:color:into:)``
- ``PGClipRectToBounds(_:)``

### Displaying triangles

- ``PGFillTriangle(_:color:)``
- ``PGFillTriangle(_:color:into:)``
