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
    let title: String
    let author: String
    let category: String
    let content: String
    let dateCreated: Double
    
    init(title: String, author: String, category: String, content: String) {
        self.hash = content.sha1Hash()
        self.title = title
        self.author = author
        self.category = category
        self.content = content
        self.dateCreated  = NSDate().timeIntervalSince1970
    }
}
