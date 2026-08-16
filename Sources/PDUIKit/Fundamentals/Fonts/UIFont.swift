import PlaydateKit
import PDFoundation

/// A structure that represents a font from a bundle's resources.
public struct UIFont {
    /// An enumeration of font weights supported.
    public enum Weight {
        /// The regular font weight.
        case regular

        /// The medium font weight.
        case medium

        /// The bold font weight.
        case bold

        var resourceSuffix: String {
            switch self {
            case .regular: "Regular"
            case .medium: "Medium"
            case .bold: "Bold"
            }
        }
    }

    /// The name of the typeface used in the font.
    public var fontName: String

    /// The size of the font in points.
    public var fontSize: Int

    /// The font's weight.
    public var fontWeight: Weight

    var pdFont: Graphics.Font?

    /// Construct a font from a given name, size, and weight.
    /// - Parameter name: The typeface to use.
    /// - Parameter size: The size of the font in points.
    /// - Parameter weight: The font's weight.
    public init(named name: String, size: Int, weight: Weight = .regular) {
        let fontResource = [name, weight.resourceSuffix, String(size)].joined(separator: "-")
        fontName = name
        fontSize = size
        fontWeight = weight
        do {
            pdFont = try Bundle.main.font(forResourceNamed: fontResource)
        } catch {
            PDReportError("Failed to instantiate font: \(error)")
        }
    }

    init(systemFontSize: Int, systemFontWeight: Weight) {
        let fontResource = ["Roobert", systemFontWeight.resourceSuffix, String(systemFontSize)].joined(separator: "-")
        fontName = "UISystemFont"
        fontSize = systemFontSize
        fontWeight = systemFontWeight
        do {
            pdFont = try Bundle.uiKit.font(forResourceNamed: fontResource)
        } catch {
            PDReportFatalError("Failed to instantiate system font: \(error)")
        }
    }
}
