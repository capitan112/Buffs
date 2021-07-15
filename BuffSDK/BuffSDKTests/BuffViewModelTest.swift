//
//  BuffViewModelTest.swift
//  BuffSDKTests
//
//  Created by Oleksiy Chebotarov on 06/07/2021.
//  Copyright © 2021 BuffUp. All rights reserved.
//

@testable import BuffSDK
import XCTest

class BuffViewModelTest: XCTestCase {
    var dataFetcher: NetworkDataFetcherProtocol!
    var buff: Buff!
    var viewModel: BuffViewModel!

    override func setUp() {
        let networkServicelocal = NetworkServiceLocal(json: buffJson)
        dataFetcher = NetworkDataFetcher(networking: networkServicelocal)
        dataFetcher.fetchBuffs(by: "1", completion: { response in
            switch response {
            case let .success(buff):
                self.buff = buff
                self.viewModel = BuffViewModel(buff)
            case let .failure(error):
                debugPrint(error.localizedDescription)
                XCTFail()
            }
        })
    }

    override func tearDown() {
        dataFetcher = nil
        viewModel = nil
    }

    func testViewModelAuthor() {
        let expectedAuthor = "Ronaldo "
        XCTAssertEqual(viewModel.author, expectedAuthor)
    }

    func testViewModelQuestion() {
        let expectedQuestion = "Kaio Jorge has 4 goals this tournament – I think he will score again today. What do you think?"
        XCTAssertEqual(viewModel.question, expectedQuestion)
    }

    func testViewModelTimeToShow() {
        let expectedTimeToShow: TimeInterval = 15.0
        XCTAssertEqual(viewModel.timeToShow, expectedTimeToShow)
    }

    func testViewModelAnswers() {
        let expectedAnswers = ["No goals!", "One goal!", "Two or more!"]
        XCTAssertEqual(viewModel.answers, expectedAnswers)
    }
}
