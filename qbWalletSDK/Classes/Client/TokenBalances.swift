//
//  TokenBalances.swift
//  WalletSDK
//
//  Created by Elvis on 20.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

struct TokenBalances: Decodable {
    let transactionCount: Int
    let balances: Balances
    let aggValue: AggregateValue
    
    init(
        transactionCount: Int,
        balances: Balances,
        aggValue: AggregateValue
        ) {
        self.transactionCount = transactionCount
        self.balances = balances
        self.aggValue = aggValue
    }
}

struct Balances {
    let privateTokens: Array<Token>
    let publicTokens: Array<Token>
    let ethBalance: ETHBalance
    
    init(
        privateTokens: Array<Token>,
        publicTokens: Array<Token>,
        ethBalance: ETHBalance
        ) {
        self.privateTokens = privateTokens
        self.publicTokens = publicTokens
        self.ethBalance = ethBalance
    }
}

extension Balances: Decodable {
    enum StructKeys: String, CodingKey {
        case privateTokens = "private"
        case publicTokens = "public"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StructKeys.self)
        let privateTokensDict = try container.decode([String: TokenIntermediate].self, forKey: .privateTokens)
        let publicTokensDict = try container.decode([String: TokenIntermediate].self, forKey: .publicTokens)
        
        var privateTokensArr: [Token] = []
        
        for (key, value) in privateTokensDict {
            privateTokensArr.append(
                Token(
                    symbol: key,
                    balance: value.balance,
                    contractAddress: Address(address: value.contractAddress!)
                )
            )
        }
        
        var publicTokensArr: [Token] = []
        var ethBalance = ETHBalance(balance: 0.0)
        
        for (key, value) in publicTokensDict {
            if (key != Constants.ETH) {
                publicTokensArr.append(
                    Token(
                        symbol: key,
                        balance: value.balance,
                        contractAddress: Address(address: value.contractAddress!)
                    )
                )
            } else {
                ethBalance = ETHBalance(balance: Decimal(string: value.balance) ?? 0.0)
            }
            
        }
        
        self.init(
            privateTokens: privateTokensArr,
            publicTokens: publicTokensArr,
            ethBalance: ethBalance
        )
    }
}

struct TokenIntermediate: Decodable {
    let contractAddress: String?
    let balance: String
}

struct AggregateValue: Decodable {
    let USD: Decimal
}

struct ETHBalance: Decodable {
    let balance: Decimal
}

