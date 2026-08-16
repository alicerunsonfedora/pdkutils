import PDFoundation

/// An item that appears in the status bar.
public struct UIStatusBarItem: Sendable {
    /// An enumeration of the available icons for a status bar item.
    public enum Icon: Sendable {
        case crank, buttonB, buttonA, menu, lock
        
        case directionPad, directionPadAndCrank, directionPadLeft, directionPadRight, directionPadUp, directionPadDown

        var text: PDString {
            switch self {
            case .directionPad: "✛"
            case .crank: "🎣"
            case .buttonA: "Ⓐ"
            case .buttonB: "Ⓑ"
            case .directionPadAndCrank: "✛/🎣"
            case .menu: "⊙"
            case .lock: "🔒"
            case .directionPadLeft: "⬅️"
            case .directionPadRight: "➡️"
            case .directionPadUp: "⬆️"
            case .directionPadDown: "⬇️"
            }
        }
    }

    /// The action text that appears in the item.
    public var action: PDString

    /// The corresponding icon to associate with the action.
    public var icon: Icon

    public init(action: PDString, icon: Icon) {
        self.action = action
        self.icon = icon
    }

    var textContent: PDString { icon.text + "  " + action }
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
    
    /// The standard status bar action for invoking the system menu.
    static let menu = UIStatusBarItem(action: "MENU", icon: .menu)
    
    /// The standard status bar action for locking the Playdate.
    static let lock = UIStatusBarItem(action: "LOCK", icon: .lock)
}