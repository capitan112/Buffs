//
//  Buff.swift
//  BuffSDK
//
//  Created by Eleftherios Charitou on 18/12/2019.
//  Copyright © 2019 BuffUp. All rights reserved.
//

import Foundation
import UIKit

public final class BuffSDK: NSObject {
    private let dataFetcher = NetworkDataFetcher()

    override public init() {
        super.init()
        registerFonts()
    }

    private func registerFonts() {
        UIFont.registerFont(withFilenameString: "Gibson-SemiBold.ttf",
                            bundle: Bundle.sdkBundle)

        UIFont.registerFont(withFilenameString: "Gibson-SemiBold.otf",
                            bundle: Bundle.sdkBundle)
    }

    internal func fetchData(with id: String, completion: @escaping (Result<Buff, Error>) -> Void) {
        dataFetcher.fetchBuffs(by: id, completion: completion)
    }

    public func showBuff(by id: String, on view: BuffView) {
        fetchData(with: id, completion: { response in
            switch response {
            case let .success(buff):
                let viewModel = BuffViewModel(buff, dataFetcher: self.dataFetcher)
                view.viewModel = viewModel
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        })
    }
}
