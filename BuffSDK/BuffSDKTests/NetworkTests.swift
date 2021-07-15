//
//  BuffSDKTests.swift
//  BuffSDKTests
//
//  Created by Eleftherios Charitou on 19/11/2019.
//  Copyright © 2019 BuffUp. All rights reserved.
//

@testable import BuffSDK
import XCTest

class NetworkTests: XCTestCase {
    var networkService: NetworkService!
    var dataFetcher: NetworkDataFetcherProtocol!
    var buff: Buff!

    override func setUp() {
        let networkServiceLocal = NetworkServiceLocal(json: buffJson)
        dataFetcher = NetworkDataFetcher(networking: networkServiceLocal)
        networkService = NetworkService()
    }

    override func tearDown() {
        dataFetcher = nil
        networkService = nil
        buff = nil
    }

    func testImageDownload() {
        dataFetcher.download(icon: "icon", completion: { response in
            switch response {
            case .success:
                debugPrint("success")
                XCTAssert(true)
            case let .failure(error):
                debugPrint(error.localizedDescription)
                XCTFail()
            }
        })
    }

    func testURLConverter() {
        guard let url = networkService.convertToURL(parameter: String(1)) else {
            XCTFail()
            return
        }

        let expected = URL(string: "https://demo2373134.mockable.io/buffs/1")
        XCTAssertEqual(url, expected)
    }

    func testDataFetcher() {
        dataFetcher.fetchBuffs(by: "1", completion: { response in
            switch response {
            case let .success(buff):
                self.buff = buff
            case let .failure(error):
                debugPrint(error.localizedDescription)
                XCTFail()
            }
        })

        let expectedQuestion = "Kaio Jorge has 4 goals this tournament – I think he will score again today. What do you think?"
        XCTAssertEqual(buff.result.question.title, expectedQuestion)
        XCTAssertEqual(buff.result.answers.count, 3)
    }
}

class NetworkServiceLocal: NetworkProtocol {
    private var charactersJson: String
    private var imageName: String

    init(json: String, imageName: String = "Generic.Answer_ico") {
        charactersJson = json
        self.imageName = imageName
    }

    func request(parameter _: String, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.success(charactersJson.data(using: .utf8)!))
    }

    func request(icon _: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let image = UIImage(named: imageName,
                            in: Bundle.sdkBundle,
                            compatibleWith: nil)
        if let data = image?.pngData() {
            completion(.success(data))
        } else {
            completion(.failure(ConversionFailure.missingData))
        }
    }
}

extension NetworkService {
    func convertToURL(parameter: String) -> URL? {
        return urlFrom(parameter: parameter)
    }
}

let buffJson = """
{
    "result": {
        "id": 1,
        "client_id": 1,
        "stream_id": 11,
        "time_to_show": 15,
        "priority": 3,
        "created_at": "2020-02-21T13:08:58.233866Z",
        "author": {
            "first_name": "Ronaldo",
            "last_name": "",
            "image": "https://res.cloudinary.com/dtgno0lg2/image/upload/v1582030534/avatars/Ronaldo_2x_yw2pnz.png"
        },
        "question": {
            "id": 491,
            "title": "Kaio Jorge has 4 goals this tournament – I think he will score again today. What do you think?",
            "category": 1
        },
        "answers": [
            {
                "id": 1163,
                "buff_id": 0,
                "title": "No goals!",
                "image": {
                    "0": {
                        "id": "public/dc21866c51ba43938ab138b86d6c13b4/a-dc21866c51ba43938ab138b86d6c13b4@1x.png",
                        "key": "dc21866c51ba43938ab138b86d6c13b4",
                        "url": "https://buffup-s3-clients-s-31d41d8cd98f00b204e9800998ecf8427e.s3.eu-west-2.amazonaws.com/public/dc21866c51ba43938ab138b86d6c13b4/a-dc21866c51ba43938ab138b86d6c13b4@1x.png"
                    },
                    "1": {
                        "id": "public/dc21866c51ba43938ab138b86d6c13b4/a-dc21866c51ba43938ab138b86d6c13b4@2x.png",
                        "key": "dc21866c51ba43938ab138b86d6c13b4",
                        "url": "https://buffup-s3-clients-s-31d41d8cd98f00b204e9800998ecf8427e.s3.eu-west-2.amazonaws.com/public/dc21866c51ba43938ab138b86d6c13b4/a-dc21866c51ba43938ab138b86d6c13b4@2x.png"
                    },
                    "2": {
                        "id": "public/dc21866c51ba43938ab138b86d6c13b4/a-dc21866c51ba43938ab138b86d6c13b4@3x.png",
                        "key": "dc21866c51ba43938ab138b86d6c13b4",
                        "url": "https://buffup-s3-clients-s-31d41d8cd98f00b204e9800998ecf8427e.s3.eu-west-2.amazonaws.com/public/dc21866c51ba43938ab138b86d6c13b4/a-dc21866c51ba43938ab138b86d6c13b4@3x.png"
                    }
                }
            },
            {
                "id": 1164,
                "buff_id": 0,
                "title": "One goal!",
                "image": {
                    "0": {
                        "id": "public/74287ffdf8d78838e2d669db7f2cbf53/a-74287ffdf8d78838e2d669db7f2cbf53@1x.png",
                        "key": "74287ffdf8d78838e2d669db7f2cbf53",
                        "url": "https://buffup-s3-clients-s-31d41d8cd98f00b204e9800998ecf8427e.s3.eu-west-2.amazonaws.com/public/74287ffdf8d78838e2d669db7f2cbf53/a-74287ffdf8d78838e2d669db7f2cbf53@1x.png"
                    },
                    "1": {
                        "id": "public/74287ffdf8d78838e2d669db7f2cbf53/a-74287ffdf8d78838e2d669db7f2cbf53@2x.png",
                        "key": "74287ffdf8d78838e2d669db7f2cbf53",
                        "url": "https://buffup-s3-clients-s-31d41d8cd98f00b204e9800998ecf8427e.s3.eu-west-2.amazonaws.com/public/74287ffdf8d78838e2d669db7f2cbf53/a-74287ffdf8d78838e2d669db7f2cbf53@2x.png"
                    },
                    "2": {
                        "id": "public/74287ffdf8d78838e2d669db7f2cbf53/a-74287ffdf8d78838e2d669db7f2cbf53@3x.png",
                        "key": "74287ffdf8d78838e2d669db7f2cbf53",
                        "url": "https://buffup-s3-clients-s-31d41d8cd98f00b204e9800998ecf8427e.s3.eu-west-2.amazonaws.com/public/74287ffdf8d78838e2d669db7f2cbf53/a-74287ffdf8d78838e2d669db7f2cbf53@3x.png"
                    }
                }
            },
            {
                "id": 1165,
                "buff_id": 0,
                "title": "Two or more!",
                "image": {
                    "0": {
                        "id": "public/043419866b39a8dd2c20b389aa45f55c/a-043419866b39a8dd2c20b389aa45f55c@1x.png",
                        "key": "043419866b39a8dd2c20b389aa45f55c",
                        "url": "https://buffup-s3-clients-s-31d41d8cd98f00b204e9800998ecf8427e.s3.eu-west-2.amazonaws.com/public/043419866b39a8dd2c20b389aa45f55c/a-043419866b39a8dd2c20b389aa45f55c@1x.png"
                    },
                    "1": {
                        "id": "public/043419866b39a8dd2c20b389aa45f55c/a-043419866b39a8dd2c20b389aa45f55c@2x.png",
                        "key": "043419866b39a8dd2c20b389aa45f55c",
                        "url": "https://buffup-s3-clients-s-31d41d8cd98f00b204e9800998ecf8427e.s3.eu-west-2.amazonaws.com/public/043419866b39a8dd2c20b389aa45f55c/a-043419866b39a8dd2c20b389aa45f55c@2x.png"
                    },
                    "2": {
                        "id": "public/043419866b39a8dd2c20b389aa45f55c/a-043419866b39a8dd2c20b389aa45f55c@3x.png",
                        "key": "043419866b39a8dd2c20b389aa45f55c",
                        "url": "https://buffup-s3-clients-s-31d41d8cd98f00b204e9800998ecf8427e.s3.eu-west-2.amazonaws.com/public/043419866b39a8dd2c20b389aa45f55c/a-043419866b39a8dd2c20b389aa45f55c@3x.png"
                    }
                }
            }
        ],
        "language": "en"
    }
}
"""
