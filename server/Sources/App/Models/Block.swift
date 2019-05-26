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
    var height: Int = 0
    var previousHash: String = ""
    var hash: String!
    let timestamp = Date().timeIntervalSince1970
    var nonce:Int
    let owner: String!
    
    private (set) var transactions = [Transaction]()
    
    // for generating the hash
    var key: String {
        get {
            let transactionData = try! JSONEncoder().encode(self.transactions)
            let transactionString = String(data: transactionData, encoding: .utf8)!
            return String(self.height) + self.previousHash + String(self.nonce) + transactionString
        }
    }
    
    init(height: Int, owner: String) {
        self.height = height
        self.owner = owner
        self.nonce = Int.random(in: 0...Int.max)
    }
    
    func addTransaction(sender: String, author: String, title: String, category: String, content: String, isHide: Bool) {
        let transaction = Transaction(sender: sender, author: author, title: title, category: category, content: content, isHide: isHide)
        self.transactions.append(transaction)
    }
    
    func appendTransaction(_ transaction: Transaction) {
        self.transactions.append(transaction)
    }
    
    func getLatestTransaction() -> Transaction? {
        return self.transactions.last
    }
    
    func getAllTransactions() -> [Transaction] {
        return self.transactions
    }
}
