import PDFoundation
import PlaydateKit

/// A view that displays a small status bar.
/// 
/// Status bars can be used to display common actions, such as pressing the A button to select or using the directional
/// pad to navigate.
/// 
/// > Tip: To ensure that your views account for the space taking up by the status bar, validate against the view's
/// > ``contentIntrinsicSize``.
public final class UIStatusBarView: UIView {
    private enum Constants {
        static var contentLabelInset: UIEdgeInsets { UIEdgeInsets(horizontal: 12, vertical: 4) }
        static let toolbarHeight: Float = 24.0
    }

    public override var contentIntrinsicSize: UISize {
        UISize(width: UISize.display.width, height: Constants.toolbarHeight)
    }

    /// Where the status bar is placed on the screen.
    /// > Important: The ``UIVerticalAlignment/center`` case is not a supported placement.
    public var statusBarPlacement: UIVerticalAlignment = .bottom {
        didSet { didSetStatusBarPlacement() }
    }

    /// The items that appear on the leading edge of the status bar.
    public var leadingBarItems: [UIStatusBarItem] {
        didSet { didSetLeadingBarItems() }
    }

    /// The items that appear on the trailing edge of the status bar.
    public var trailingBarItems: [UIStatusBarItem] {
        didSet { didSetTrailingBarItems() }
    }

    private lazy var leftContentLabel: UILabel = {
        let label = UILabel(frame: self.frame.inset(by: Constants.contentLabelInset))
        label.font = .preferredSystemFont(for: .caption)
        label.textColor = .white
        return label
    }()

    private lazy var rightContentLabel: UILabel = {
        let label = UILabel(frame: self.frame.inset(by: Constants.contentLabelInset))
        label.font = .preferredSystemFont(for: .caption)
        label.textColor = .white
        label.textAlignment = .trailing
        return label
    }()

    public init() {
        self.leadingBarItems = []
        self.trailingBarItems = []
        super.init(
            frame: UIRect(
                at: UIRect.display.origin,
                size: UISize(width: UISize.display.width, height: Constants.toolbarHeight)
            )
        )
        self.backgroundColor = .black
        addSubview(leftContentLabel)
        addSubview(rightContentLabel)
    }

    private func didSetLeadingBarItems() {
        var text = ""
        for item in leadingBarItems {
            text += item.textContent + "    "
        }
        leftContentLabel.text = text
        setNeedsDraw()
    }

    private func didSetTrailingBarItems() {
        var text = ""
        for item in trailingBarItems {
            text += item.textContent + "    "
        }
        rightContentLabel.text = text
        setNeedsDraw()
    }

    private func didSetStatusBarPlacement() {
        switch statusBarPlacement {
        case .top:
            self.frame.origin = .zero
            setNeedsDraw()
        case .bottom:
            self.frame.origin = Point(x: 0, y: UISize.display.height - Constants.toolbarHeight)
            setNeedsDraw()
        case .center:
            PDReportWarning("Center alignment is unsupported for a status bar.")
        }
        leftContentLabel.frame = self.frame.inset(by: Constants.contentLabelInset)
        rightContentLabel.frame = self.frame.inset(by: Constants.contentLabelInset)
    }
}

