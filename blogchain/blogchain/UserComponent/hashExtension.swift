//
//  hashExtension.swift
//  blogchain
//
//  Created by 李宇沛 on 28/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import Foundation
import CommonCrypto

extension Data {
    func authenticationCode(secretKey: String = "") -> Data {
        guard let secretKeyData = secretKey.data(using: .utf8) else {
            fatalError()
        }
        return authenticationCode(secretKey: secretKeyData)
    }

    func authenticationCode(secretKey: Data) -> Data {
        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_SHA256_DIGEST_LENGTH))
        defer {
            hashBytes.deallocate()
        }
        withUnsafeBytes { (buffer) in
            secretKey.withUnsafeBytes({ (secretKeyBuffer) in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256),
                    secretKeyBuffer.baseAddress!,
                    secretKeyBuffer.count,
                    buffer.baseAddress!,
                    buffer.count,
                    hashBytes)
            })
        }
        return Data(bytes: hashBytes, count: Int(CC_SHA256_DIGEST_LENGTH))
    }
}

extension Data {
    func hash256() -> Data {
        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_SHA256_DIGEST_LENGTH))
        defer {
            hashBytes.deallocate()
        }
        withUnsafeBytes { (buffer) -> Void in
            CC_SHA256(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
        }
        return Data(bytes: hashBytes, count: Int(CC_SHA256_DIGEST_LENGTH))
    }
}
