//
//  NetworkDataFetcher.swift
//  BuffSDK
//
//  Created by Oleksiy Chebotarov on 03/07/2021.
//

import Foundation
import UIKit

enum ConversionFailure: Error {
    case invalidKey(CodingKey, DecodingError.Context)
    case typeMismatch(Any.Type, DecodingError.Context)
    case dataCorrupted(DecodingError.Context)
    
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
        fetchData(id: id, response: completion)
    }

    private func fetchData<T: Decodable>(id: String, response: @escaping (Result<T, Error>) -> Void) {
        networking.request(parameter: id) { dataResponse in
            guard let data = try? dataResponse.get() else {
                response(.failure(ConversionFailure.responceError))
                return
            }

            self.decodeData(from: data, completion: response)
        }
    }

    private func decodeData<T: Decodable>(from data: Data?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let data = data else {
            completion(.failure(ConversionFailure.missingData))
            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let result = try decoder.decode(T.self, from: data)
            completion(.success(result))
        } catch DecodingError.keyNotFound(let key, let contex) {
            debugPrint("keyNotFound: \(key) contex: \(contex)")
            completion(.failure(ConversionFailure.invalidKey(key, contex)))
        } catch DecodingError.typeMismatch(let type, let contex) {
            completion(.failure(ConversionFailure.typeMismatch(type, contex)))
            debugPrint("typeMismatch: \(type) contex: \(contex)")
        } catch DecodingError.dataCorrupted(let contex) {
            debugPrint("dataCorrupted with contex: \(contex)")
            completion(.failure(ConversionFailure.dataCorrupted(contex)))
        } catch {
            debugPrint("not recognized error")
        }
    }
}
