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
    // Regex
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs, options: .caseInsensitive) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
