//
//  SDKProvider.swift
//  WalletSDK
//
//  Created by Elvis on 05.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

internal protocol SDKProvider {
    // Storage related
    static func walletAddress() -> Result<Address, Error>
    static func privateKey() -> Result<PrivateKey, Error>
    static func mnemonicPhrase() -> Result<Mnemonic, Error>
    
    // Wallet related
    static func createWallet() -> Result<Wallet, Error>
    static func restoreWallet(mnemonic: Mnemonic) -> Result<Wallet, Error>
    static func removeWallet() -> Result<(), Error>
    
    // Backend API related
    static func getBalances(
        responseHandler: @escaping  (_ result: Result<TokenBalances, Error>) -> ()
    )
    
    static func getTokens(
        responseHandler: @escaping (_ result: Result<Tokens, Error>) -> ()
    )
    
    static func getTransactions(
        responseHandler: @escaping (_ result: Result<Array<Transaction>, Error>) -> ()
    )
    
    static func sendTransaction(
        toAddress: Address,
        contractAddress: Address,
        sendTokenValue: Double,
        responseHandler:  @escaping (_ result: Result<Hash, Error>) -> ()
    )
    
}
