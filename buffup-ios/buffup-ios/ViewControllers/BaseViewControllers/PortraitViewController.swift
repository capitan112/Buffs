//
//  PortraitViewController.swift
//  buffup-ios
//
//  Created by Eleftherios Charitou on 04/12/2019.
//  Copyright © 2019 BuffUp. All rights reserved.
//

import UIKit

class PortraitViewController: UIViewController {
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
