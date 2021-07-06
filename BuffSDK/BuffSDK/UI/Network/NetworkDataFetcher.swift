//
//  NetworkDataFetcher.swift
//  BuffSDK
//
//  Created by Oleksiy Chebotarov on 03/07/2021.
//

import Foundation
import UIKit

enum ConversionFailure: Error {
    case invalidData
    case missingData
    case responceError
}

protocol NetworkDataFetcherProtocol {
    func fetchBuffs(by id: String, completion: @escaping (Result<Buff, Error>) -> Void)
    func download(icon: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class NetworkDataFetcher: NetworkDataFetcherProtocol {
    var networking: NetworkProtocol

    init(networking: NetworkProtocol = NetworkService()) {
        self.networking = networking
    }

    func download(icon: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        networking.request(icon: icon, completion: { response in
            switch response {
            case let .success(data):
                completion(.success(UIImage(data: data)!))
            case let .failure(error):
                debugPrint(error.localizedDescription)
                completion(.failure(error))
            }
        })
    }

    func fetchBuffs(by id: String, completion: @escaping (Result<Buff, Error>) -> Void) {
        fetchGenericJSONData(id: id, response: completion)
    }

    private func fetchGenericJSONData(id: String, response: @escaping (Result<Buff, Error>) -> Void) {
        networking.request(parameter: id) { dataResponse in
            guard let data = try? dataResponse.get() else {
                response(.failure(ConversionFailure.responceError))
                return
            }

            self.decodeJSON(from: data, completion: response)
        }
    }

    private func decodeJSON(from data: Data?, completion: @escaping (Result<Buff, Error>) -> Void) {
        guard let data = data else {
            completion(.failure(ConversionFailure.missingData))
            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let result = Result(catching: {
                try decoder.decode(Buff.self, from: data)
            })

            completion(result)
        }
    }
}
