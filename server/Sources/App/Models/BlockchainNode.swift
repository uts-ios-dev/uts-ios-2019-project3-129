//
//  BlockchainNode.swift
//  App
//
//  Created by AnLuoRidge on 25/5/19.
//

import Foundation
import Vapor

final class BlockchainNode: Content {
    var address: String
    init(address:String) {
        self.address = address
    }
}
