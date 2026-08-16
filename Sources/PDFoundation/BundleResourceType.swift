//
//  BundleResourceType.swift
//  PDKUtils
//
//  Created by Marquis Kurt on 05-02-2026.
//

/// A protocol that defines a type of resource that can be located in a ``Bundle``.
public protocol BundleResourceType {
    /// Whether the resource type requires the file's extension.
    ///
    /// Default resource types such as images and sounds often do not require a file extension, as the Playdate SDK
    /// implicitly determines the correct extension. Set this value to `true` if the SDK cannot implicitly determine
    /// the file extension.
    var requiresFileExtension: Bool { get }

    /// Retrieves the subpath to a resource relative to the bundle's resource path.
    /// - Parameter name: The name of the resource to retrieve.
    func subpath(name: String) -> String
}

/// A resource type that describes image data.
public struct ImageResourceType: BundleResourceType {
    public var requiresFileExtension: Bool { false }
    public func subpath(name: String) -> String {
        "/Images/\(name)"
    }
}

/// A resource type that describes sound or waveform data.
public struct SoundResourceType: BundleResourceType {
    public var requiresFileExtension: Bool { false }
    public func subpath(name: String) -> String {
        "/Sounds/\(name)"
    }
}

/// A resource type that describes font data.
public struct FontResourceType: BundleResourceType {
    public var requiresFileExtension: Bool { false }
    public func subpath(name: String) -> String {
        "/Fonts/\(name)"
    }
}

/// A resource type that describes text data stored as JavaScript Object Notation (JSON).
public struct JSONResourceType: BundleResourceType {
    public var requiresFileExtension: Bool { true }
    public func subpath(name: String) -> String {
        "/Data/\(name).json"
    }
}

public extension BundleResourceType where Self == ImageResourceType {
    /// The resource type associated with images.
    static var image: ImageResourceType { ImageResourceType() }
}

public extension BundleResourceType where Self == SoundResourceType {
    /// The resource type associated with sounds or waveform data.
    static var sound: SoundResourceType { SoundResourceType() }
}

public extension BundleResourceType where Self == FontResourceType {
    /// The resource type associated with font data.
    static var font: FontResourceType { FontResourceType() }
}

public extension BundleResourceType where Self == JSONResourceType {
    /// The resource type associated with data stored as JavaScript Object Notation (JSON).
    static var json: JSONResourceType { JSONResourceType() }
}
