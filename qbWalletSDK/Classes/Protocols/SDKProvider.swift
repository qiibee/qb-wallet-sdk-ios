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
    func walletAddress() -> Result<Address, Error>
    func privateKey() -> Result<PrivateKey, Error>
    func mnemonicPhrase() -> Result<Mnemonic, Error>
    
    // Wallet related
    func createWallet() -> Result<Address, Error>
    func restoreWallet(mnemonic: Mnemonic) -> Result<Address, Error>
    func removeWallet() -> Result<(), Error>
    
    // Backend API related
    func getBalances(
        responseHandler: (_ result: Result<TokenBalances, Error>) -> ()
    )
    
    static func getTokens(
        responseHandler: @escaping (_ result: Result<Tokens, Error>) -> ()
    )
    
    func getTransactions(
        responseHandler: (_ result: Result<Array<Transaction>, Error>) -> ()
    )
    
    func sendTransaction(
        toAddress: Address,
        contractAddress: Address,
        sendTokenValue: Decimal,
        responseHandler: (_ result: Result<Hash, Error>) -> ()
    )
    
}
