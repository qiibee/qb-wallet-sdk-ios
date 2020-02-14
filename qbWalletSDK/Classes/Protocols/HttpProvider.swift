//
//  HttpClient.swift
//  WalletSDK
//
//  Created by Elvis on 05.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

internal protocol HttpClient {
    static func getBalances(
        address: Address,
        responseHandler: @escaping (_ result: Result<TokenBalances, Error>) -> ()
    )
    
    static func getTokens(
        address: Address,
        responseHandler: @escaping (_ result: Result<Tokens, Error>) -> ()
    )
    
    static func getTransactions(
        address: Address,
        responseHandler: @escaping (_ result: Result<Array<Transaction>, Error>) -> ()
    )
    
    static func sendSignedTransaction(
        signedTx: String,
        responseHandler: @escaping (_ result: Result<String, Error>) -> ()
    )    
    
    static func getRawTransaction(
        fromAddress: Address,
        toAddress: Address,
        contractAddress: Address,
        sendTokenValue: Decimal,
        privateKey: PrivateKey,
        responseHandler: @escaping (_ result: Result<String, Error>) -> ()
    )
}
