//
//  UILabel+AttributedText.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 9/29/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import Foundation

extension UILabel {
    func setTextWith(font: UIFont?, letterSpacing: Float, color: UIColor, lineHeight: CGFloat = 1.0, text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: letterSpacing),
            NSFontAttributeName: font!,
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}