//
//  String+.swift
//  App
//
//  Created by AnLuoRidge on 25/5/19.
//

import Foundation
import Crypto

extension String {
    func sha256() -> String? {
        do {
            let digest = try SHA256.hash(self)
            return digest.hexEncodedString()
        } catch {
            return nil
        }
    }
}
