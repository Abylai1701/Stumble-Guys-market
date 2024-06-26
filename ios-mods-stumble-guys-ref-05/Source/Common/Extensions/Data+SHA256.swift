//
//  Data+SHA256.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 05.12.2023.
//

import CommonCrypto
import Foundation

func adiwQSJ51fqwfaDwsa_e0Q04() -> Int {
    let result = Int.random(in: 1...100) + Int.random(in: 1...100)
    return result
}

extension Data {
    func sha256() -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
