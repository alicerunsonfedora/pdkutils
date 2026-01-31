//
//  Bundle.swift
//  PDFoundation 
//
//  Created by Marquis Kurt on 19-12-2025.
//

import PlaydateKit

/// An object that represents a game's bundle.
public class Bundle {
    /// An enumeration of the available resource types in a bundle.
    public enum ResourceType {
        /// The model resource type.
        case model

        /// The scene resource type.
        case scene

        /// The image resource type.
        case image

        func subpath(name: String) -> String {
            switch self {
            case .model:
                "/Models/\(name).model"
            case .scene:
                "/Scenes/\(name).pdscene"
            case .image:
                "/Images/\(name)"
            }
        }
    }

    var resourcesBase: String

    /// Create a game bundle relative to a given path.
    /// - Parameter path: The relative path of the bundle.
    public init(path: String? = nil) {
        if let path {
            resourcesBase = "\(path)/Resources"
        } else {
            resourcesBase = "Resources"
        }
    }

    /// Retrieve the file system path for a given resource.
    /// - Parameter resource: The name of the resource to locate.
    /// - Parameter resourceType: The type of resource to locate.
    public func path(forResource resource: String, ofType resourceType: ResourceType) -> String? {
        let resPath = resourcesBase + resourceType.subpath(name: resource)
        guard File.fileExists(at: resPath) else {
            return nil
        }
        return resPath
    }
}

// swiftlint:disable discouraged_direct_init

extension Bundle {
    /// The main bundle.
    public static var main: Bundle {
        let bundle = Bundle()
        return bundle
    }
}

// swiftlint:enable discouraged_direct_init
