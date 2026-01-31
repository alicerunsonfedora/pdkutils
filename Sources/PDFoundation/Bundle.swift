//
//  Bundle.swift
//  PDFoundation 
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

/// An enumeration of the errors that can occur when accessing a bundle's resources.
public enum BundleAccessError: Error {
    /// No such resource exists in the bundle.
    case noSuchFileExists

    /// An unknown error occurred when creating the resource.
    case readError(Playdate.Error)
}

/// An object that represents a game's bundle.
public class Bundle {
    /// An enumeration of the available resource types in a bundle.
    ///
    /// Resource types have standard bundle paths and can be interpreted by consumers by any means necessary. The
    /// ``Bundle`` class provides common implementations for accessing these resource types
    /// (see: <doc:Bundle#Accessing-bundle-resources>). Not all bundles require every resource type in this enumeration
    /// to be available.
    public enum ResourceType {
        /// The resource type for 3D models.
        case model

        /// The resource type for 3D scenes.
        case scene

        /// The resource type for images.
        case image

        /// The resource type for bitmap fonts.
        case font

        /// The resource type for sounds.
        case sound
    }

    var resourcesBase: String

    /// Create a bundle relative to a given path for a specific name.
    ///
    /// Use this initializer when creating a bundle that is intended to be separated from the ``main`` bundle.
    /// - Parameter name: The name of the bundle.
    /// - Parameter path: The relative path of the bundle.
    public init(named name: String, path: String? = nil) {
        if let path {
            resourcesBase = "\(path)/\(name).pdbundle/Resources"
        } else {
            resourcesBase = "\(name).pdbundle/Resources"
        }
    }

    /// Create a game bundle relative to a given path.
    /// - Parameter path: The relative path of the bundle.
    init(path: String? = nil) {
        if let path {
            resourcesBase = "\(path)/Resources"
        } else {
            resourcesBase = "Resources"
        }
    }

    /// Retrieve the file system path for a given resource in the bundle.
    /// - Parameter resource: The name of the resource to locate.
    /// - Parameter resourceType: The type of resource to locate.
    public func path(forResource resource: String, ofType resourceType: ResourceType) -> String? {
        let resPath = resourcesBase + resourceType.subpath(name: resource)
        if !resourceType.requiresFileExtension {
            return resPath
        }
        if !File.fileExists(at: resPath) {
            return nil
        }
        return resPath
    }
}

// swiftlint:disable discouraged_direct_init

extension Bundle {
    /// The bundle associated with the main Playdate app or game.
    public static var main: Bundle {
        Bundle()
    }

    /// Retrieves an image resource of a specified name.
    /// - Parameter name: The name of the image resource to retrieve.
    public func image(forResourceNamed name: String) throws(BundleAccessError) -> Graphics.Bitmap {
        guard let path = path(forResource: name, ofType: .image) else {
            throw .noSuchFileExists
        }
        do {
            return try Graphics.Bitmap(path: path)
        } catch {
            throw .readError(error)
        }
    }

    /// Retrieves a font resource of a specified name.
    /// - Parameter name: The name of the font resource to retrieve.
    public func font(forResourceNamed name: String) throws(BundleAccessError) -> Graphics.Font {
        guard let path = path(forResource: name, ofType: .font) else {
            throw .noSuchFileExists
        }
        do {
            return try Graphics.Font(path: path)
        } catch {
            throw .readError(error)
        }
    }
}

// swiftlint:enable discouraged_direct_init

extension Bundle.ResourceType {
    func subpath(name: String) -> String {
        switch self {
        case .model:
            "/Models/\(name).model"
        case .scene:
            "/Scenes/\(name).pdscene"
        case .image:
            "/Images/\(name)"
        case .font:
            "/Fonts/\(name)"
        case .sound:
            "/Sounds/\(name)"
        }
    }

    var requiresFileExtension: Bool {
        switch self {
        case .model, .scene:
            return true
        case .image, .font, .sound:
            return false
        }
    }
}
