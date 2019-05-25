//
//  Block.swift
//  App
//
//  Created by AnLuoRidge on 25/5/19.
//

import Foundation
import Vapor

// A block can have multiple transactions
final class Block: Content{
    // the position in the blockchain
    var index: Int = 0
    var previousHash: String = ""
    var hash: String!
    var nonce:Int
    
    private (set) var transactions = [Transaction]()
    
    // for generating the hash
    var key: String {
        get {
            let transactionData = try! JSONEncoder().encode(self.transactions)
            let transactionString = String(data: transactionData, encoding: .utf8)!
            return String(self.index) + self.previousHash + String(self.nonce) + transactionString
        }
    }
    
    init() {
        self.nonce = 0
    }
    
    func addTransaction(title: String, author: String, category: String, content: String) {
        let transaction = Transaction(title: title, author: author, category: category, content: content)
        self.transactions.append(transaction)
    }
    
    func getLatestTransaction() -> Transaction? {
        return self.transactions.last
    }
}
