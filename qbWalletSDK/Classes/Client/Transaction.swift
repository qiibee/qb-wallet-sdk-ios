//
//  Transaction.swift
//  WalletSDK
//
//  Created by Elvis on 21.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

public struct Transaction: Decodable {
    let to: Address
    let from: Address
    let contractAddress: Address
    let timestamp: TimeInterval
    let token: Token
    
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
