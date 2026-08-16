//
//  Bundle+PDUIKit.swift
//  PDKUtils
//
//  Created by Marquis Kurt on 31-01-2026.
//

import PlaydateKit
import PDFoundation

public extension Bundle {
    /// The bundle containing resources for PDUIKit.
    static var uiKit: Bundle {
        Bundle(named: "PDUIKit")
    }

    /// Retrieves an image resource from the bundle.
    /// - Parameter name: The name of the image resource to retrieve.
    func image(forResourceNamed name: String) throws(BundleAccessError) -> UIImage {
        let realImage: Graphics.Bitmap = try self.image(forResourceNamed: name)
        return UIImage(name: name, bitmap: realImage)
    }
}
