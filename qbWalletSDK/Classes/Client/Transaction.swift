//
//  Transaction.swift
//  WalletSDK
//
//  Created by qiibee on 21.01.20.
//  Copyright © 2020 qiibee. All rights reserved.
//

import Foundation

public struct Transaction {
    public let to: Address
    public let from: Address
    public let contractAddress: Address
    public let timestamp: TimeInterval
    public let token: Token
    
    init(
        to: Address,
        from: Address,
        contractAddress: Address,
        timestamp: TimeInterval,
        token: Token
    ) {
        self.to = to
        self.from = from
        self.contractAddress = contractAddress
        self.timestamp = timestamp
        self.token = token
    }
}
