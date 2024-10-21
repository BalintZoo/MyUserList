//
//  KeyChainHelper.swift
//  MyUserList
//
//  Created by Zoltan Balint on 03.10.2024.
//

import Foundation
import Security

class KeychainHelper {
    
    static let shared = KeychainHelper()

    private init() { }
    
    func save(_ data: Data, forKey key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        /// Delete any existing item
        SecItemDelete(query)

        /// Add new item to keychain
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            print("Keychain save error: \(status)")
        }
    }

    func read(forKey key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            print("Keychain read error: \(status)")
            return nil
        }
    }

    func delete(forKey key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        let status = SecItemDelete(query)
        if status != errSecSuccess {
            print("Keychain delete error: \(status)")
        }
    }
}
