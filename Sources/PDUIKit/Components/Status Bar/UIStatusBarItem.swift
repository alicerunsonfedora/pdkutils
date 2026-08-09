import PDFoundation

/// An item that appears in the status bar.
public struct UIStatusBarItem: Sendable {
    /// An enumeration of the available icons for a status bar item.
    public enum Icon: Sendable {
        case directionPad, crank, buttonB, buttonA, directionPadAndCrank

        var text: String {
            switch self {
            case .directionPad: "✛"
            case .crank: "🎣"
            case .buttonA: "Ⓐ"
            case .buttonB: "Ⓑ"
            case .directionPadAndCrank: "✛/🎣"
            }
        }
    }

    /// The action text that appears in the item.
    public var action: String

    /// The corresponding icon to associate with the action.
    public var icon: Icon

    public init(action: String, icon: Icon) {
        self.action = action
        self.icon = icon
    }

    var textContent: String { icon.text + "  " + action }
}

public extension UIStatusBarItem {
    /// The standard status bar action for confirming an operation.
    static let confirmation = UIStatusBarItem(action: "CONFIRM", icon: .buttonA)

    /// The standard status bar action for selecting an item.
    static let select = UIStatusBarItem(action: "SELECT", icon: .buttonA)
    
    /// The standard status bar action for going back.
    static let back = UIStatusBarItem(action: "BACK", icon: .buttonB)
    
    /// The standard status bar action for moving within a grid or layout.
    static let move = UIStatusBarItem(action: "MOVE", icon: .directionPad)
}