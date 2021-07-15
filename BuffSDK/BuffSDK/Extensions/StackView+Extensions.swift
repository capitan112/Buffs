//
//  StackView+Extensions.swift
//  BuffSDK
//
//  Created by Oleksiy Chebotarov on 04/07/2021.
//  Copyright © 2021 BuffUp. All rights reserved.
//

import Foundation
import UIKit

public extension UIStackView {
    func addBackground(color: UIColor, cornerRadius: CGFloat = 15.0) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subview.layer.cornerRadius = cornerRadius
        subview.layer.masksToBounds = true
        subview.clipsToBounds = true
        insertSubview(subview, at: 0)
    }
}

extension UIStackView {
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }

    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}
