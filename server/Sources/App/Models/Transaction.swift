//
//  Transaction.swift
//  App
//
//  Created by AnLuoRidge on 25/5/19.
//

import Foundation
import Vapor

// may change to Blog structure
final class Transaction: Content {
    var title: String
    var category: String
    var content: String
    var dateCreated: Double
    
    init(title: String, category: String,content:String) {
        self.title = title
        self.category = category
        self.content = content
        self.dateCreated  = NSDate().timeIntervalSince1970
    }
}
