//
//  BlockchainService.swift
//  App
//
//  Created by 庄鸣真 on 2019/5/22.
//

import Foundation
import Vapor

class BlockchainService: Service {
    private (set) var blockchain: Blockchain!
    
    init() {
        self.blockchain = Blockchain()
        
        // TODO: FAKE DATA
        #if DEBUG
        let tranA = Transaction(sender: "sender-hash-tester", author: "TESTER", title: "Remembering", category: "IT", content: "C", isHide: false)
        let tranB = Transaction(sender: "sender-hash-tester", author: "TESTER", title: "Forgetness", category: "Medicine", content: "R", isHide: false)
        let tranC = Transaction(sender: "sender-hash-tester", author: "TESTER", title: "Forgetfulness", category: "Medecine", content: "Ark", isHide: false)
        let tranD = Transaction(sender: "sender-hash-tester2", author: "Daniel", title: "Tuition pumps", category: "Medecine", content: "# Preview", isHide: false)
        let tranE = Transaction(sender: "sender-hash-tester2", author: "Daniel", title: "Tuition pumps", category: "Medecine", content: "# Preview", isHide: true)
        _ = addNewBlockWith(transaction: tranA)
        _ = addNewBlockWith(transaction: tranB)
        try! appendTransactionToBlock(hash: self.blockchain.getLastBlock().hash, transaction: tranC)
        _ = addNewBlockWith(transaction: tranD)
        try! appendTransactionToBlock(hash: self.blockchain.getLastBlock().previousHash, transaction: tranE)
        #endif
    }
    
    func getBlockchain() -> Blockchain {
        return self.blockchain
    }
    
    func registerNodes(nodes:[BlockchainNode]) -> [BlockchainNode] {
        return self.blockchain.registerNodes(nodes: nodes)
    }
    
    func getNodes() -> [BlockchainNode] {
        return self.blockchain.nodes
    }
    
    func getLatestTransactionsByUser(hash userHash: String) -> [Transaction] {
        var transactions = [Transaction]()
        self.blockchain.blocks.forEach { (block) in
            if (block.owner == userHash) {
                if let transaction = block.getLatestTransaction() {
                    transactions.append(transaction)
                }
            }
        }
        return transactions
    }
    // new article
    func addNewBlockWith(transaction: Transaction) -> String {
        let block = Block(height: self.blockchain.blocks.count, owner: transaction.sender)
        block.appendTransaction(transaction)
        self.blockchain.appendBlock(block)
        return self.blockchain.getLastBlock().hash
    }
    // update/delete article
    func appendTransactionToBlock(hash: String, transaction: Transaction) throws {
        guard let block = self.blockchain.getBlockBy(hash: hash) else { throw BlockError.blockHashNotExist }
        block.appendTransaction(transaction)
    }
    
    func resolve(completion : @escaping (Blockchain) -> ()) {
        let nodes = self.blockchain.nodes
        for node in nodes {
            let url = URL(string :"\(node.address)/blockchain")!
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    let blockchain = try! JSONDecoder().decode(Blockchain.self, from: data)
                    if self.blockchain.blocks.count > blockchain.blocks.count {
                        completion(self.blockchain)
                    } else {
                        self.blockchain = blockchain
                        completion(blockchain)
                    }
                }
            }.resume()
        }
    }
}
