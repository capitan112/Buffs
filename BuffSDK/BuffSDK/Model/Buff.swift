//
//  File.swift
//  BuffSDK
//
//  Created by Oleksiy Chebotarov on 03/07/2021.
//

import Foundation

// MARK: - Buff

public struct Buff: Decodable {
    let result: Details
}

// MARK: - Result

public struct Details: Decodable {
    let id: Int
    let clientID: Int?
    let timeToShow: Int
    let priority: Int
    let createdAt: String
    let author: Author
    let question: Question
    let answers: [Answer]
    let language: String
}

// MARK: - Answer

public struct Answer: Decodable {
    let id: Int
    let buffID: Int?
    let title: String
    let image: [String: Image]
}

// MARK: - Image

struct Image: Decodable {
    let id: String
    let key: String
    let url: String
}

// MARK: - Author

public struct Author: Codable {
    let firstName: String
    let lastName: String
    let image: String
}

// MARK: - Question

public struct Question: Decodable {
    let id: Int
    let title: String
    let category: Int
}
