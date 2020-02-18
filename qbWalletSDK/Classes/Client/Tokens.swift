
//
//  Tokens.swift
//  WalletSDK
//
//  Created by Elvis on 10.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

public struct Tokens {
    public let privateTokens: [Token]
    public let publicTokens: [Token]
    
    init(
        privateTokens: [Token],
        publicTokens: [Token]
    ) {
        self.privateTokens = privateTokens
        self.publicTokens = publicTokens
    }
}

public struct Token {
    public let symbol: String
    public let balance: String
    public let contractAddress: Address
    
    init(
        symbol: String,
        balance: String,
        contractAddress: Address
    ) {
        self.symbol = symbol
        self.balance = balance
        self.contractAddress = contractAddress
    }
}
