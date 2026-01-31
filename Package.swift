// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let playdateSDKPath: String = if let path = Context.environment["PLAYDATE_SDK_PATH"] {
    path
} else {
    "\(Context.environment["HOME"]!)/Developer/PlaydateSDK/"
}

let package = Package(
    name: "PDKUtils",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "PDFoundation", targets: ["PDFoundation"]),
        .library(name: "PDGraphics", targets: ["PDGraphics", "PDFoundation"]),
        .library(name: "PDUIKit", targets: ["PDUIKit", "PDGraphics", "PDFoundation"]),
    ],
    traits: [
        .default(enabledTraits: ["PDGraphicsXOR"]),
        .trait(name: "PDGraphicsXOR")
    ],
    dependencies: [
        .package(url: "https://source.marquiskurt.net/PDUniverse/PlaydateKit.git", branch: "main")
    ],
    targets: [
        .pdTarget(name: "PDFoundation"),
        .pdTarget(name: "PDGraphics", dependencies: ["PDFoundation"]),
        .pdTarget(
            name: "PDUIKit",
            dependencies: ["PDFoundation", "PDGraphics"],
            exclude: ["Resources"]
        ),
    ]
)

extension Target {
    static func pdTarget(
        name: String,
        dependencies: [Target.Dependency] = [],
        exclude: [String] = [],
        swiftSettings: [SwiftSetting] = [],
        cSettings: [CSetting] = []
    ) -> Target {
        var swiftFlags = [
            "-whole-module-optimization",
            "-Xfrontend", "-disable-objc-interop",
            "-Xfrontend", "-disable-stack-protector",
            "-Xfrontend", "-function-sections",
            "-Xcc", "-DTARGET_EXTENSION",
            "-Xcc", "-I", "-Xcc", "\(playdateSDKPath)/C_API"
        ]
        
        #if RELEASE
            swiftFlags.append(contentsOf: ["-Xfrontend", "-gline-tables-only"])
        #endif

        let defaultDepends: [Target.Dependency] = [.product(name: "PlaydateKit", package: "PlaydateKit")]
        let defaultSettings: [SwiftSetting] = [
            .enableExperimentalFeature("Embedded"),
            .unsafeFlags(swiftFlags)
        ]
        return .target(
            name: name,
            dependencies: defaultDepends + dependencies,
            exclude: exclude,
            cSettings: cSettings,
            swiftSettings: defaultSettings + swiftSettings
        )
    }
}
