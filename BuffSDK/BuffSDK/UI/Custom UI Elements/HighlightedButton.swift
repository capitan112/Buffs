//
//  HighlightedButton.swift
//  BuffSDK
//
//  Created by Oleksiy Chebotarov on 06/07/2021.
//  Copyright © 2021 BuffUp. All rights reserved.
//

import Foundation
import UIKit

class HighlightedButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            if superview?.backgroundColor != nil {
                superview?.backgroundColor = .green
            } else {
                superview?.subviews.first?.backgroundColor = .green
            }
            isEnabled = false
        }
    }
}
