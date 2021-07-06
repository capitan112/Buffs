//
//  UIView+Extensions.swift
//  BuffSDK
//
//  Created by Eleftherios Charitou on 16/01/2020.
//  Copyright © 2020 BuffUp. All rights reserved.
//

import UIKit

protocol Anchors {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
}

extension UIView: Anchors {}
extension UILayoutGuide: Anchors {}

extension UIView {
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
    }
}

extension UIView {
    func bind<T: Anchors>(to view: T, top: CGFloat = 0.0, bottom: CGFloat = 0.0, left: CGFloat = 0.0, right: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false

        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: left).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: right).isActive = true
    }

    func bindSize(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false

        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
