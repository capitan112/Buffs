//
//  BuffQuestionnaireViewModel.swift
//  BuffSDK
//
//  Created by Oleksiy Chebotarov on 04/07/2021.
//  Copyright © 2021 BuffUp. All rights reserved.
//

import Foundation
import UIKit

public class BuffViewModel {
    private(set) var buff: Buff
    private let dataFetcher: NetworkDataFetcherProtocol

    internal func getAuthorIcon(completion: @escaping (Result<UIImage, Error>) -> Void) {
        dataFetcher.download(icon: buff.result.author.image, completion: completion)
    }

    init(_ buff: Buff, dataFetcher: NetworkDataFetcherProtocol = NetworkDataFetcher()) {
        self.buff = buff
        self.dataFetcher = dataFetcher
    }

    lazy var author: String = {
        buff.result.author.firstName
            + " "
            + buff.result.author.lastName
    }()

    lazy var question: String = {
        buff.result.question.title
    }()

    lazy var answers: [String] = {
        var answers = [String]()
        for answer in buff.result.answers {
            answers.append(answer.title)
        }

        return answers
    }()

    lazy var timeToShow: TimeInterval = {
        TimeInterval(buff.result.timeToShow)
    }()

    func buttonTapped(button: UIButton) {
        debugPrint("button tag tapped: \(button.tag)")
    }
}
