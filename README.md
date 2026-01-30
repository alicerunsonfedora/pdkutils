# PDKUtils

**PDKUtils** is a meta Swift package that aims to fill in the gaps of
PlaydateKit by providing a comprehensive set of tools used to make apps
and games for the Playdate.

> **Important**  
> PDKUtils is a work-in-progress SDK, and some features may not be
> complete. At this time, PDKUtils is not considered production-ready. Use
> at your own risk!

## What PDKUtils includes

PDKUtils is designed to be portable, letting you pick from a range of
libraries that you might need:

- `PDFoundation` aims to provide fundamental capabilities akin to the
  Foundation framework found on Apple's devices.
- `PDGraphics` provides functions and utilities for more performant
  graphics operations such as drawing scanlines, triangles, and
  rectangles.
- `PDUIKit` lets developers create user interfaces for their Playdate apps
  and games with a system that feels similar to Apple's UIKit.

## Getting started

Start by adding `PDKUtils` to your package dependencies with the Swift
Package Manager:

```swift
dependencies: [
    .package(
        url: "https://source.marquiskurt.net/PDUniverse/PDKUtils.git",
        branch: "main")
]
```

Then, in your PlaydateKit target, add the dependency:

```swift
targets: [
    .target(
        name: "MyGame",
        dependencies: [
            .product(name: "PDFoundation", package: "PDKUtils")
        ]
    )
]
```

## Contribute to PDKUtils

This project is currently accepting contributions through GitHub until
Forgejo and other Git repository hosting services support federated pull
requests.

> **Note**  
> GitHub is treated as a _mirror_ with the exception for public pull
> requests. The source of truth can be found on SkyVault at
> https://source.marquiskurt.net/PDUniverse/PDKUtils.

## License

PDKUtils is a free and open-source library licensed under the MIT License.
For more information on your rights, refer to LICENSE.txt. 

## Credits

PDKUtils is made possible thanks to the following open source projects:

- [PlaydateKit](https://github.com/finvoor/PlaydateKit) - MIT License