
//
//  Tokens.swift
//  WalletSDK
//
//  Created by Elvis on 10.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

public struct Tokens {
    public let privateTokens: Array<Token>
    public let publicTokens: Array<Token>
    
    init(
        privateTokens: Array<Token>,
        publicTokens: Array<Token>
    ) {
        self.privateTokens = privateTokens
        self.publicTokens = publicTokens
    }
}

extension Tokens: Decodable {
    enum StructKeys: String, CodingKey {
        case privateTokens = "private"
        case publicTokens = "public"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StructKeys.self)
        let privateTokens = try container.decode([Token].self, forKey: .privateTokens)
        let publicTokens = try container.decode([Token].self, forKey: .publicTokens)
        
        self.init(
            privateTokens: privateTokens,
            publicTokens: publicTokens
        )
    }
}

public struct Token: Decodable {
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
