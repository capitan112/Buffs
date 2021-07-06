//
//  BuffsSDKTests.swift
//  BuffSDKTests
//
//  Created by Oleksiy Chebotarov on 04/07/2021.
//  Copyright © 2021 BuffUp. All rights reserved.
//

@testable import BuffSDK
import XCTest

class BuffsSDKTests: XCTestCase {
    var buffSDK: BuffSDK!

    override func setUpWithError() throws {
        buffSDK = BuffSDK()
    }

    override func tearDownWithError() throws {
        buffSDK = nil
    }

    func testFetchData() throws {
        let expectation = XCTestExpectation(description: "Download apple.com home page")

        buffSDK.fetchData(with: "2") { response in

            switch response {
            case let .success(buff):
                let expectedQuestion = "Do you think that is a penalty?"
                XCTAssertEqual(buff.result.question.title, expectedQuestion)
                XCTAssertEqual(buff.result.answers.count, 2)
                expectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
