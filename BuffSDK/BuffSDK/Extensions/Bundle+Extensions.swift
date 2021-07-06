//
//  Bundle+Extensions.swift
//  BuffSDK
//
//  Created by Eleftherios Charitou on 14/02/2020.
//  Copyright © 2020 BuffUp. All rights reserved.
//

import Foundation

extension Bundle {
    class var sdkBundle: Bundle {
        return Bundle(identifier: "com.buffup.BuffSDK")!
    }
}
