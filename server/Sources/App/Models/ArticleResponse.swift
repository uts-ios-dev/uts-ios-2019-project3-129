//
//  ArticleResponse.swift
//  App
//
//  Created by AnLuoRidge on 6/6/19.
//

import Foundation
import Vapor

struct ArticleResponse: Content {
    let hash: String
    let sender: String
    let author: String
    let title: String
    let category: String
    let content: String
    let dateCreated: Double
    let isHide: Bool
    let articleAddress: String
    
    init(transaction: Transaction, articleAddress: String) {
        self.hash = transaction.hash
        self.sender = transaction.sender
        self.author = transaction.author
        self.title = transaction.title
        self.category = transaction.category
        self.content = transaction.content
        self.dateCreated  = transaction.dateCreated
        self.isHide = transaction.isHide
        self.articleAddress = articleAddress
    }
}
