//
//  Blockchain.swift
//  App
//
//  Created by AnLuoRidge on 25/5/19.
//

import Foundation
import Vapor

final class Blockchain: Content {
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
