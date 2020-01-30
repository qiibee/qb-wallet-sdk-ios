//
//  Entities.swift
//  WalletSDK
//
//  Created by Elvis on 05.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

struct Address: Decodable {
    let address: String
    
    init(address: String) {
        // TODO check is address correct
        self.address = address
    }
}

struct PrivateKey {
    let privateKey: String
    
    init(privateKey: String) {
        // TODO check is privateKey correct
        self.privateKey = privateKey
    }
}

struct Mnemonic {
    let phrase: String
    
    init(phrase: String) {
        // TODO check is phrase correct
        self.phrase = phrase
    }
}

struct Hash: Decodable {
    
}

struct Wallet {
    let privateKey: String
    let publicKey: String
    let mnemonic: String
    
    init(
        privateKey: String,
        publicKey: String,
        mnemonic: String
        ) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.mnemonic = mnemonic
    }
}
