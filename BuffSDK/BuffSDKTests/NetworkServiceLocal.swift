//
//  NetworkServiceLocal.swift
//  BuffSDKTests
//
//  Created by Oleksiy Chebotarov on 16/07/2021.
//  Copyright © 2021 BuffUp. All rights reserved.
//

import Foundation
import UIKit
@testable import BuffSDK

class NetworkServiceLocal: NetworkProtocol {
    private var charactersJson: String

    init(json: String) {
        charactersJson = json
    }

    func request(parameter _: String, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.success(charactersJson.data(using: .utf8)!))
    }

    func request(icon name: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let image = UIImage(named: name,
                            in: Bundle.sdkBundle,
                            compatibleWith: nil)
        if let data = image?.pngData() {
            completion(.success(data))
        } else {
            completion(.failure(ConversionFailure.missingData))
        }
    }
}
