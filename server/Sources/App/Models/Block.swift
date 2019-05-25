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
    
    // for generating hash
    var key: String{
        get{
            let transactionData = try! JSONEncoder().encode(self.transactions)
            let transactionString = String(data: transactionData, encoding: .utf8)!
            return String(self.index) + self.previousHash+String(self.nonce)+transactionString
        }
    }
    
    func addTransaction(transaction: Transaction) {
        self.transactions.append(transaction)
    }
    
    init() {
        self.nonce = 0
    }
}
