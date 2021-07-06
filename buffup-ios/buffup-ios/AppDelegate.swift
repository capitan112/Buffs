//
//  AppDelegate.swift
//  buffup-ios
//
//  Created by Eleftherios Charitou on 18/09/2019.
//  Copyright © 2019 BuffUp. All rights reserved.
//

import BuffSDK
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupBuffSDK()
        return true
    }
}

extension AppDelegate {
    private func setupBuffSDK() {
        // TODO: Add your SDK initialization logic here if needed
    }
}
