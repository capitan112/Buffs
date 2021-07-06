//
//  PaddingLabel.swift
//  BuffSDK
//
//  Created by Oleksiy Chebotarov on 06/07/2021.
//  Copyright © 2021 BuffUp. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PaddingLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var bottomInset: CGFloat = 10.0
    @IBInspectable var leftInset: CGFloat = 2.0
    @IBInspectable var rightInset: CGFloat = 2.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
