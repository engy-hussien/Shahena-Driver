//
//  PaddingLabel.swift
//  MandobiDriver
//
//  Created by ِAmr on 2/8/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 20.0
    @IBInspectable var bottomInset: CGFloat = 20.0
    @IBInspectable var leftInset: CGFloat = 20.0
    @IBInspectable var rightInset: CGFloat = 20.0
    
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
        
        let textWidth = frame.size.width - (self.leftInset + self.rightInset)
        let newSize = self.text!.boundingRectWithSize(CGSizeMake(textWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.font], context: nil)
        intrinsicSuperViewContentSize.height = ceil(newSize.size.height) + self.topInset + self.bottomInset
        
        return intrinsicSuperViewContentSize
    }
}
