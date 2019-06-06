//
//  keyChainExtension.swift
//  blogchain
//
//  Created by 李宇沛 on 27/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import Foundation
import Security
import CommonCrypto
import SnapKit

class keyChainExtension {

    enum account: String {
        case pinCode = "www.blockchain.com.pinCode"
        case privateKey = "www.blockchain.com.privateKey"
    }

    static private var _pinCode: String?
    static var pinCode: String? {
        get {
            if (_pinCode != nil) {
                return _pinCode
            }
            print(getKeyChainItem(account: account.pinCode.rawValue))
            return _pinCode
        }
    }


    static private var _keyAddress: String?
    static var keyAddress: String? {
        get {
            if (_keyAddress != nil) {
                return _keyAddress
            }
            print(getKeyChainItem(account: account.privateKey.rawValue))
            return _keyAddress
        }
    }

    static func createDefaultKeyChainItemDic(account: String) -> NSMutableDictionary {
        let keyChainItem = NSMutableDictionary()
        keyChainItem.setObject(kSecClassKey as NSString, forKey: kSecClass as NSString)
        keyChainItem.setObject("www.blogChain.com", forKey: kSecAttrServer as NSString)
        keyChainItem.setObject(account, forKey: kSecAttrAccount as NSString)
        return keyChainItem
    }

    static func addKeyChain(account: String, key: String) -> OSStatus {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
//                                    kSecAttrServer as String: "www.blockchain.com",
                                    kSecValueData as String: key.data(using: String.Encoding.utf8)!]
        let status = SecItemAdd(query as CFDictionary, nil)
        print(status.words)
        return status
    }

    static func updateKeyChainItem(account: String, newKey: String) -> OSStatus {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account]
        
        if SecItemCopyMatching(query as CFDictionary, nil) == noErr{
            let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                             kSecValueData as String: newKey.data(using: String.Encoding.utf8)!]
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            print(status)
            return status
        }else{
            return (6)
        }
    }

    static func deleteKeyChainItem(account: String) -> OSStatus {
        let keyChainItem = self.createDefaultKeyChainItemDic(account: account)
        if SecItemCopyMatching(keyChainItem, nil) == noErr {
            let status = SecItemDelete(keyChainItem)
            return status
        } else {
            return OSStatus(6)
        }
    }

    static func getKeyChainItem(account: String) -> OSStatus {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true,
                                    kSecAttrAccount as String: account,
                                    kSecMatchLimit as String: kSecMatchLimitOne]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if (status != 0) {
            return status
        }
        guard let existingItem = item as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
            return OSStatus(12)
        }
        switch account {
        case self.account.pinCode.rawValue:
            _pinCode = password
            break
        default:
            _keyAddress = password
            break
        }

        return OSStatus(0)
    }

    static func validationOfPinCode(hash: String) -> Bool {
        let secret = UIDevice.current.identifierForVendor!.uuidString.data(using: .utf8)!
        let re = hash.data(using: .utf8)?.authenticationCode(secretKey: secret).base64EncodedString()
        return pinCode == re
    }
}
