import PDFoundation
import PlaydateKit

public extension Graphics {
    /// Draws a given string to the screen in the given rectangle.
    /// > Tip: For more fine-grained control inside a ``UIView``, consider using ``UILabel`` instead.
    /// 
    /// - Parameter text: The text to draw the screen.
    /// - Parameter rect: The UI rectangle to draw into.
    /// - Parameter font: The UI font to draw the text as.
    /// - Parameter wrap: The text wrapping.
    /// - Parameter aligned: The text alignment.
    static func drawTextInRect(
        _ text: PDString,
        in rect: UIRect,
        font: UIFont = .preferredSystemFont(for: .body),
        wrap: TextWrap = .clip,
        aligned: TextAlignment = .left
    ) {
        guard let pdFont = font.pdFont else { return }
        Graphics.setFont(pdFont)
        Graphics.drawTextInRect(text.string, in: rect.pdRect, wrap: wrap, aligned: aligned)
    }

    /// Draws a given string to the screen in the given rectangle.
    /// > Tip: For more fine-grained control inside a ``UIView``, consider using ``UILabel`` instead.
    /// 
    /// - Parameter text: The text to draw the screen.
    /// - Parameter rect: The UI rectangle to draw into.
    /// - Parameter font: The UI font to draw the text as.
    /// - Parameter wrap: The text wrapping.
    /// - Parameter aligned: The text alignment.
    static func drawTextInRect(
        _ text: String,
        in rect: UIRect,
        font: UIFont = .preferredSystemFont(for: .body),
        wrap: TextWrap = .clip,
        aligned: TextAlignment = .left
    ) {
        guard let pdFont = font.pdFont else { return }
        Graphics.setFont(pdFont)
        Graphics.drawTextInRect(text, in: rect.pdRect, wrap: wrap, aligned: aligned)
    }
}