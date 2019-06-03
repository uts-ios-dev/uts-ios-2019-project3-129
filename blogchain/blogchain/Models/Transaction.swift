//
//  Transaction.swift
//  blogchain
//
//  Created by 庄鸣真 on 2019/5/28.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import Foundation

// A version of article
struct Transaction: Codable {
    let hash: String // generate from the content
    let sender: String // farc757a-3fvb-4bdf-a418-15a29870c82a
    let author: String
    let title: String
    let category: String
    let content: String
    let dateCreated: Double
    let isHide: Bool
}

struct Article: Codable {
    let title: String
    let author: String
    let sender: String
    let category: String
    let content: String
    let isHide: Bool
}

struct UpdateArticle: Codable {
    let articleAddress:String
    let title: String
    let author: String
    let sender: String
    let category: String
    let content: String
    var isHide: Bool
    
    init(address: String, article:Article) {
        self.articleAddress = address
        self.title = article.title
        self.author = article.author
        self.sender = article.sender
        self.category = article.category
        self.content = article.content
        self.isHide = article.isHide
    }
}

struct PostArticleResult: Codable{
    let articleAddress: String
}
