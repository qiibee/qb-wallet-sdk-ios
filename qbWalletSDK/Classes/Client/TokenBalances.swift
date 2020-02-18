//
//  TokenBalances.swift
//  WalletSDK
//
//  Created by Elvis on 20.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

public struct TokenBalances {
    public let transactionCount: Int
    public let balances: Balances
    public let aggValue: AggregateValue
    
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

public struct Balances {
    public let privateTokens: [Token]
    public let publicTokens: [Token]
    public let ethBalance: ETHBalance
    
    init(
        privateTokens: [Token],
        publicTokens: [Token],
        ethBalance: ETHBalance
    ) {
        self.privateTokens = privateTokens
        self.publicTokens = publicTokens
        self.ethBalance = ethBalance
    }
}

public struct AggregateValue {
    public let USD: String
}

public struct ETHBalance {
    public let balance: String
}

