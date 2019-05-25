//
//  Models.swift
//  App
//
//  Created by 庄鸣真 on 2019/5/22.
//

import Foundation
import Vapor

final class BlockchainNode : Content {
    var address: String
    init(address:String) {
        self.address = address
    }
}
// may change to Blog structure
final class Transaction : Content {
    var title: String
    var category: String
    var content: String 
//    var createDate: Double

    init(title: String, category: String,content:String) {
        self.title = title
        self.category = category
        self.content = content
//        self.createDate  = NSDate().timeIntervalSince1970
    }
}

// A block can have multiple transactions
final class Block : Content{
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

final class Blockchain:Content{
    private (set) var blocks = [Block]()
    private (set) var nodes  = [BlockchainNode]()
    
    
    init(genesisBlock: Block) {
        addBlock(genesisBlock)
    }
    func registerNodes(nodes:[BlockchainNode])->[BlockchainNode]{
        self.nodes.append(contentsOf: nodes)
        return self.nodes
    }
    func addBlock(_ block: Block){
        if self.blocks.isEmpty {
            block.previousHash = "0000000000000000"
            block.hash = generateHash(for: block)
        }
        self.blocks.append(block)
    }
    
    func getNextBlock(transactions: [Transaction])->Block {
        let block = Block()
        transactions.forEach{ transaction in
            block.addTransaction(transaction: transaction)
        }
        let previousBlock = getPreviousBlock()
        block.index = self.blocks.count
        block.previousHash = previousBlock.hash
        block.hash = generateHash(for: block)
        return block
    }
    
    private func getPreviousBlock()->Block {
        return self.blocks[self.blocks.count - 1]
    }
    
    // run algorithms -> find the hash -> add the block in the blockchain
    func generateHash(for block: Block)->String{
        var hash = block.key.sha1Hash()
        while(!hash.hasPrefix("00")){
            block.nonce+=1
            hash = block.key.sha1Hash()
            print(hash)
        }
        return hash
    }
}

extension String {
    func sha1Hash()->String {
        let task = Process()
        task.launchPath = "/usr/bin/shasum"
        task.arguments = []
        
        let inputPipe = Pipe()
        inputPipe.fileHandleForWriting.write(self.data(using: .utf8)!)
        inputPipe.fileHandleForWriting.closeFile()
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardInput = inputPipe
        task.launch()
        
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let hash = String(data: data, encoding: .utf8)!
        return hash.replacingOccurrences(of: "  -\n", with: "")
    }
}
