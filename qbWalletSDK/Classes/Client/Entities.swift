//
//  Entities.swift
//  WalletSDK
//
//  Created by Elvis on 05.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

public struct Hash {
    public let hash: String
    public init(hash: String) {
        self.hash = hash
    }
}

public struct Address {
    public let address: String
    
    public init(address: String) throws {
        if (Assertion.isValidAddress(address: address)) {
            self.address = address
        } else {
            throw ClientEntityErrors.InvalidWalletAddress
        }
        
    }
}

public struct PrivateKey {
    public let privateKey: String
    
    public init(privateKey: String) {
        self.privateKey = privateKey
    }
}

public struct Mnemonic {
    public let phrase: String
    
    public init(phrase: String) throws {
        if (Assertion.isValidMnemonic(phrase: phrase)) {
            self.phrase = phrase
        } else {
            throw ClientEntityErrors.InvalidMnemonicPhrase
        }
        
    }
}

public struct Wallet {
    public let privateKey: PrivateKey
    public let publicKey: Address
    public let mnemonic: Mnemonic
    
    public init(
        privateKey: PrivateKey,
        publicKey: Address,
        mnemonic: Mnemonic
    ) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.mnemonic = mnemonic
    }
}
