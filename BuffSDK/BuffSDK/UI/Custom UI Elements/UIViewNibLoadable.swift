//
//  UIViewNibLoadable.swift
//  BuffSDK
//
//  Created by Eleftherios Charitou on 16/01/2020.
//  Copyright © 2020 BuffUp. All rights reserved.
//

import UIKit

public class UIViewNibLoadable: UIView {
    private var nibContentView: UIView!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
    }

    func initFromNib() {
        let bundle = Bundle.sdkBundle
        let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        nibContentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(nibContentView)
        nibContentView.bindFrameToSuperviewBounds()
    }
}
