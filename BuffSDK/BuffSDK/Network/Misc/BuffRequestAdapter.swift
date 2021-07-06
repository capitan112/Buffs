//
//  BuffRequestAdapter.swift
//  BuffSDK
//
//  Created by Eleftherios Charitou on 12/12/2019.
//  Copyright © 2019 BuffUp. All rights reserved.
//

import Alamofire
import Foundation
import JWTDecode

class BuffRequestAdapter: RequestAdapter {
    enum AdapterType {
        case SDK
        case Request
        case None
    }

    private let timeOut = 30.0
    private let device = Device()
    private var adapterType: AdapterType

    init(adapter: AdapterType) {
        adapterType = adapter
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if let jwtToken = BuffTokenManager.shared.getToken(adapter: adapterType), let expireDate = try? decode(jwt: jwtToken).expiresAt {
            if Date() >= expireDate {
                BuffTokenManager.shared.clearToken(adapter: adapterType)
                BuffSDK.instance.refreshToken()
                throw StandardError.expiredToken
            } else if Date().addingTimeInterval(3600) >= expireDate {
                // if the token expires within the next hour, refresh it
                BuffSDK.instance.refreshToken()
            }
            urlRequest.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        }

        urlRequest.setValue(device.appVersion, forHTTPHeaderField: "AppVersion")
        urlRequest.setValue(device.modelName, forHTTPHeaderField: "DeviceModel")
        urlRequest.setValue(device.osVersion, forHTTPHeaderField: "DeviceOSVersion")
        urlRequest.setValue(device.platform, forHTTPHeaderField: "DevicePlatform")
        urlRequest.setValue(device.uuid, forHTTPHeaderField: "DeviceID")
        urlRequest.setValue(TimeZone.current.identifier, forHTTPHeaderField: "Timezone")
        urlRequest.timeoutInterval = timeOut
        return urlRequest
    }
}
