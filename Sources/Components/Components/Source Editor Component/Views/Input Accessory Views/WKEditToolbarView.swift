import Foundation
import UIKit

class WKEditToolbarView: WKComponentView { //class EditToolbarView: UIView, TextFormattingButtonsProviding {
    //weak var delegate: TextFormattingDelegate?
    
    @IBOutlet var separatorViews: [UIView] = []
    @IBOutlet var buttons: [WKTextFormattingButton] = []

    override var intrinsicContentSize: CGSize {
        let height = buttons.map { $0.intrinsicContentSize.height }.max() ?? UIView.noIntrinsicMetric
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //accessibilityElements = buttons
    }
}
