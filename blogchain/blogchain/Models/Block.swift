//
//  Block.swift
//  blogchain
//
//  Created by 庄鸣真 on 2019/5/28.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import Foundation

// A block can have multiple transactions
struct Block:Codable {
    // the position in the blockchain
    var height: Int
    var previousHash: String
    var hash: String
    var timestamp :Float
    var nonce:Int
    var owner: String
    var transactions : [Transaction]
}
