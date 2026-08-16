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
public final class Bundle {
    var resourcesBase: PDString

    /// Create a bundle relative to a given path for a specific name.
    ///
    /// Use this initializer when creating a bundle that is intended to be separated from the ``main`` bundle.
    /// - Parameter name: The name of the bundle.
    /// - Parameter path: The relative path of the bundle.
    public init(named name: PDString, path: PDString? = nil) {
        if let path {
            resourcesBase = "\(path)/\(name).pdbundle/Resources"
        } else {
            resourcesBase = "\(name).pdbundle/Resources"
        }
    }

    /// Create a game bundle relative to a given path.
    /// - Parameter path: The relative path of the bundle.
    init(path: PDString? = nil) {
        if let path {
            resourcesBase = "\(path)/Resources"
        } else {
            resourcesBase = "Resources"
        }
    }

    /// Retrieve the file system path for a given resource in the bundle.
    /// - Parameter resource: The name of the resource to locate.
    /// - Parameter resourceType: The type of resource to locate.
    public func path(forResource resource: PDString, ofType resourceType: some BundleResourceType) -> PDString? {
        let resPath = resourcesBase + resourceType.subpath(pdName: resource)
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
    public func image(forResourceNamed name: PDString) throws(BundleAccessError) -> Graphics.Bitmap {
        guard let path = path(forResource: name, ofType: .image) else {
            throw .noSuchFileExists
        }
        do {
            return try Graphics.Bitmap(path: path.string)
        } catch {
            throw .readError(error)
        }
    }

    /// Retrieves a font resource of a specified name.
    /// - Parameter name: The name of the font resource to retrieve.
    public func font(forResourceNamed name: PDString) throws(BundleAccessError) -> Graphics.Font {
        guard let path = path(forResource: name, ofType: .font) else {
            throw .noSuchFileExists
        }
        do {
            return try Graphics.Font(path: path.string)
        } catch {
            throw .readError(error)
        }
    }
}

// swiftlint:enable discouraged_direct_init
