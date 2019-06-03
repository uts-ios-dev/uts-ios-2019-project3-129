//
//  Blockchain.swift
//  blogchain
//
//  Created by 庄鸣真 on 2019/5/28.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import Foundation

struct Blockchain: Codable {
    let blocks : [Block]
    let nodes  : [BlockchainNode]
}
