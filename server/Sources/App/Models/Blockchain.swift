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
    
    init() {
        let genesisBlock = Block(height: 0, owner: "BlogChain");
        genesisBlock.previousHash = "0000000000000000"
        genesisBlock.hash = "0000000000000001"
        self.blocks.append(genesisBlock)
    }
    
    init(data: [Block]) {
        // TODO
    }
    
    func registerNodes(nodes:[BlockchainNode]) -> [BlockchainNode]{
        self.nodes.append(contentsOf: nodes)
        return self.nodes
    }
    
    func appendBlock(_ block: Block) {
        block.previousHash = self.blocks.last!.hash
        block.hash = block.key.sha256()!
        self.blocks.append(block)
    }
    
    func getBlockAt(height: Int) -> Block {
        return self.blocks[height]
    }
    // get article by hash address
//    func getTransactionBy(hash: String) -> Transaction {
//
//    }
    
    // We don't need mining for now.
    // run algorithms -> find the hash -> add the block in the blockchain
//    func generateHash(for block: Block) -> String {
//        var hash = block.key.sha1Hash()
//        while(!hash.hasPrefix("00")){
//            block.nonce += 1
//            hash = block.key.sha1Hash()
//            print(hash)
//        }
//        return hash
//    }
}
