import UIKit

protocol WKEditorToolbarExpandingViewDelegate: AnyObject {
    func toolbarExpandingViewDidTapFind(toolbarExpandingView: WKEditorToolbarExpandingView)
    func toolbarExpandingViewDidTapFormatText(toolbarExpandingView: WKEditorToolbarExpandingView)
    func toolbarExpandingViewDidTapFormatHeading(toolbarExpandingView: WKEditorToolbarExpandingView)
}

class WKEditorToolbarExpandingView: WKEditorToolbarView {
    
    // MARK: - Nested Types
    
    private enum ActionsType: CGFloat {
        case primary
        case secondary

        static func visible(rawValue: RawValue) -> ActionsType {
            if rawValue == 0 {
                return .primary
            } else {
                return .secondary
            }
        }

        static func next(rawValue: RawValue) -> ActionsType {
            if rawValue == 0 {
                return .secondary
            } else {
                return .primary
            }
        }
    }
    
    // MARK: IBOutlet Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var formatTextButton: WKEditorToolbarButton!
    @IBOutlet weak var formatHeadingButton: WKEditorToolbarButton!
    @IBOutlet weak var citationButton: WKEditorToolbarButton!
    @IBOutlet weak var linkButton: WKEditorToolbarButton!
    @IBOutlet weak var templateButton: WKEditorToolbarButton!
    @IBOutlet weak var mediaButton: WKEditorToolbarButton!
    @IBOutlet weak var findInPageButton: WKEditorToolbarButton!
    
    @IBOutlet weak var unorderedListButton: WKEditorToolbarButton!
    @IBOutlet weak var orderedListButton: WKEditorToolbarButton!
    @IBOutlet weak var decreaseIndentionButton: WKEditorToolbarButton!
    @IBOutlet weak var increaseIndentionButton: WKEditorToolbarButton!
    @IBOutlet weak var cursorUpButton: WKEditorToolbarButton!
    @IBOutlet weak var cursorDownButton: WKEditorToolbarButton!
    @IBOutlet weak var cursorLeftButton: WKEditorToolbarButton!
    @IBOutlet weak var cursorRightButton: WKEditorToolbarButton!
    
    @IBOutlet weak var expandButton: WKEditorToolbarNavigatorButton!
    
    // MARK: Other Properties
    
    weak var delegate: WKEditorToolbarExpandingViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        expandButton.isAccessibilityElement = false
        expandButton.setImage(WKIcon.chevonRightCircleFill, for: .normal)
        expandButton.addTarget(self, action: #selector(tappedExpand), for: .touchUpInside)
        
        formatTextButton.setImage(WKIcon.formatText, for: .normal)
        formatTextButton.addTarget(self, action: #selector(tappedFormatText), for: .touchUpInside)
        
        formatHeadingButton.setImage(WKIcon.formatHeading, for: .normal)
        formatHeadingButton.addTarget(self, action: #selector(tappedFormatHeading), for: .touchUpInside)
        
        citationButton.setImage(WKIcon.citation, for: .normal)
        citationButton.addTarget(self, action: #selector(tappedCitation), for: .touchUpInside)
        
        linkButton.setImage(WKIcon.link, for: .normal)
        linkButton.addTarget(self, action: #selector(tappedLink), for: .touchUpInside)
        
        templateButton.setImage(WKIcon.template, for: .normal)
        templateButton.addTarget(self, action: #selector(tappedTemplate), for: .touchUpInside)
        
        mediaButton.setImage(WKIcon.media, for: .normal)
        mediaButton.addTarget(self, action: #selector(tappedMedia), for: .touchUpInside)
        
        findInPageButton.setImage(WKIcon.find, for: .normal)
        findInPageButton.addTarget(self, action: #selector(tappedFindInPage), for: .touchUpInside)
        
        unorderedListButton.setImage(WKIcon.unorderedList, for: .normal)
        unorderedListButton.addTarget(self, action: #selector(tappedUnorderedList), for: .touchUpInside)
        
        orderedListButton.setImage(WKIcon.orderedList, for: .normal)
        orderedListButton.addTarget(self, action: #selector(tappedOrderedList), for: .touchUpInside)
        
        decreaseIndentionButton.setImage(WKIcon.decreaseIndent, for: .normal)
        decreaseIndentionButton.addTarget(self, action: #selector(tappedDecreaseIndentation), for: .touchUpInside)
        
        increaseIndentionButton.setImage(WKIcon.increaseIndent, for: .normal)
        increaseIndentionButton.addTarget(self, action: #selector(tappedIncreaseIndentation), for: .touchUpInside)
        
        cursorUpButton.setImage(WKIcon.chevonUp, for: .normal)
        cursorUpButton.addTarget(self, action: #selector(tappedCursorUp), for: .touchUpInside)
        
        cursorDownButton.setImage(WKIcon.chevonDown, for: .normal)
        cursorDownButton.addTarget(self, action: #selector(tappedCursorDown), for: .touchUpInside)
        
        cursorLeftButton.setImage(WKIcon.chevonLeft, for: .normal)
        cursorLeftButton.addTarget(self, action: #selector(tappedCursorLeft), for: .touchUpInside)
        
        cursorRightButton.setImage(WKIcon.chevonRight, for: .normal)
        cursorRightButton.addTarget(self, action: #selector(tappedCursorRight), for: .touchUpInside)
        
        updateColors()
    }
    
    override public func appEnvironmentDidChange() {
        super.appEnvironmentDidChange()
        updateColors()
    }
    
    private func updateColors() {
        backgroundColor = WKAppEnvironment.current.theme.background
    }

    // MARK: Button actions
    
    @objc func tappedExpand() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let offsetX = scrollView.contentOffset.x
        let actionsType = ActionsType.next(rawValue: offsetX)
        
        let transform = CGAffineTransform.identity
        let buttonTransform: () -> Void
        let newOffsetX: CGFloat
        
        let sender = expandButton

        switch actionsType {
        case .primary:
            buttonTransform = {
                sender?.transform = transform
            }
            newOffsetX = 0
        case .secondary:
            buttonTransform = {
                sender?.transform = transform.rotated(by: 180 * CGFloat.pi)
                sender?.transform = transform.rotated(by: -1 * CGFloat.pi)
            }
            newOffsetX = stackView.bounds.width / 2
        }

        let scrollViewContentOffsetChange = {
            self.scrollView.setContentOffset(CGPoint(x: newOffsetX , y: 0), animated: false)
        }

        let buttonAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.7, animations: buttonTransform)
        let scrollViewAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: scrollViewContentOffsetChange)

        buttonAnimator.startAnimation()
        scrollViewAnimator.startAnimation()
    }

    @objc func tappedFormatText() {
        formatTextButton.isSelected.toggle()
        delegate?.toolbarExpandingViewDidTapFormatText(toolbarExpandingView: self)
    }
    
    @objc func tappedFormatHeading() {
        formatHeadingButton.isSelected.toggle()
        delegate?.toolbarExpandingViewDidTapFormatHeading(toolbarExpandingView: self)
    }

    @objc func tappedCitation() {
        citationButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapReference()
    }

    @objc func tappedLink() {
        linkButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapLink()
    }

    @objc func tappedUnorderedList() {
        unorderedListButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapUnorderedList()
    }

    @objc func tappedOrderedList() {
        orderedListButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapOrderedList()
    }

    @objc func tappedDecreaseIndentation() {
        decreaseIndentionButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapDecreaseIndent()
    }

    @objc func tappedIncreaseIndentation() {
        increaseIndentionButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapIncreaseIndent()
    }

    @objc func tappedCursorUp() {
        cursorUpButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapCursorUp()
    }

    @objc func tappedCursorDown() {
        cursorDownButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapCursorDown()
    }

    @objc func tappedCursorLeft() {
        cursorLeftButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapCursorLeft()
    }

    @objc func tappedCursorRight() {
        cursorRightButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapCursorRight()
    }

    @objc func tappedTemplate() {
        templateButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapTemplate()
    }

    @objc func tappedFindInPage() {
        findInPageButton.isSelected.toggle()
        delegate?.toolbarExpandingViewDidTapFind(toolbarExpandingView: self)
    }

    @objc func tappedMedia() {
        mediaButton.isSelected.toggle()
        //delegate?.textFormattingProvidingDidTapMediaInsert()
    }

}
