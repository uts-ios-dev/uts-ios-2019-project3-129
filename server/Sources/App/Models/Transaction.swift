//
//  Transaction.swift
//  App
//
//  Created by AnLuoRidge on 25/5/19.
//

import Foundation
import Vapor

// A version of article
final class Transaction: Content {
    let hash: String // generate from the content
    let sender: String // farc757a-3fvb-4bdf-a418-15a29870c82a
    let author: String
    let title: String
    let category: String
    let content: String
    let dateCreated: Double
    let isHide: Bool
    
    init(sender: String, author: String, title: String, category: String, content: String, isHide: Bool) {
        self.hash = content.sha256()!
        self.sender = sender
        self.author = author
        self.title = title
        self.category = category
        self.content = content
        self.dateCreated  = Date().timeIntervalSince1970
        self.isHide = isHide
    }
}
