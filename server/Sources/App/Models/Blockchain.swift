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
        let genesisBlock = Block();
        genesisBlock.previousHash = "0000000000000000"
        genesisBlock.hash = "0000000000000001"
        self.blocks.append(genesisBlock)
    }
    
    func registerNodes(nodes:[BlockchainNode]) -> [BlockchainNode]{
        self.nodes.append(contentsOf: nodes)
        return self.nodes
    }
    
    func appendBlock(_ block: Block) {
        block.previousHash = self.blocks.last!.hash
        block.hash = block.key.sha1Hash()
        self.blocks.append(block)
    }
    
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
