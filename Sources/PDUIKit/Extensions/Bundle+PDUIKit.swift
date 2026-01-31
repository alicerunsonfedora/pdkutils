//
//  Bundle+PDUIKit.swift
//  PDKUtils
//
//  Created by Marquis Kurt on 31-01-2026.
//

import PDFoundation

public extension Bundle {
    /// The bundle containing resources for PDUIKit.
    public static var uiKit: Bundle {
        Bundle(named: "PDUIKit")
    }
}
