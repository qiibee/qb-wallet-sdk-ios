//
//  CryptoWallet.swift
//  WalletSDK
//
//  Created by Elvis on 23.12.19.
//  Copyright © 2019 Elvis. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

final public class CryptoWallet: SDKProvider {
    
    private init() {}
    
    public static func walletAddress() -> Result<Address, Error> {
         StorageService.walletAddress()
    }

    public static func privateKey() -> Result<PrivateKey, Error> {
        StorageService.privateKey()
    }

    public static func mnemonicPhrase() -> Result<Mnemonic, Error> {
        StorageService.mnemonicPhrase()
    }

    public static func createWallet() -> Result<Wallet, Error> {
        switch CryptoService.createMnemonic() {
            case .success(let mnemonic):
                return handleWalletCreation(mnemonic: mnemonic)
            case .failure(let error):
                return .failure(error)
        }
    }

    public static func restoreWallet(mnemonic: Mnemonic) -> Result<Wallet, Error> {
        handleWalletCreation(mnemonic: mnemonic)
    }

    public static func removeWallet() -> Result<(), Error> {
        StorageService.removeWallet()
    }

    public static func getBalances(
        responseHandler: @escaping (Result<TokenBalances, Error>) -> ()
    ) -> () {
        switch StorageService.walletAddress() {
            case .success(let address):
                ApiService.getBalances(address: address, responseHandler: responseHandler)
            case .failure(let err): responseHandler(.failure(err))
        }
        
    }

    public static func getTokens(
        responseHandler: @escaping (Result<Tokens, Error>) -> ()
    ) -> () {
        switch StorageService.walletAddress() {
            case .success(let address):
                ApiService.getTokens(address: address, responseHandler: responseHandler)
            case .failure(let err): responseHandler(.failure(err))
        }
    }

    public static func getTransactions(
        responseHandler: @escaping (Result<Array<Transaction>, Error>) -> ()
    ) -> () {
        switch StorageService.walletAddress() {
            case .success(let address):
                ApiService.getTransactions(address: address, responseHandler: responseHandler)
            case .failure(let err): responseHandler(.failure(err))
        }
    }
    
    public static func sendTransaction(
        toAddress: Address,
        contractAddress: Address, 
        sendTokenValue: Double,
        responseHandler: @escaping (Result<Hash, Error>) -> ()
    ) -> () {
            getRawTx(
                toAddress: toAddress,
                contractAddress: contractAddress,
                sendTokenValue: sendTokenValue,
                responseHandler: { result in
                    switch result {
                        case .success(let rawTx): ApiService.sendSignedTransaction(
                            signedTx: rawTx,
                            responseHandler: responseHandler
                        )
                        case .failure(let err): responseHandler(.failure(err))
                    }
                }
            )
    }
    
    static func getRawTx(
        toAddress: Address,
        contractAddress: Address,
        sendTokenValue: Double,
        responseHandler: @escaping (Result<String, Error>) -> ()
    ) -> () {
        switch (StorageService.walletAddress(), StorageService.privateKey()) {
            case (.success(let address), .success(let privateKey)):
                ApiService.getRawTransaction(
                    fromAddress: address,
                    toAddress: toAddress,
                    contractAddress: contractAddress,
                    sendTokenValue: sendTokenValue,
                    privateKey: privateKey,
                    responseHandler: responseHandler
                )
            case _: responseHandler(.failure(StorageErrors.WalletAddressEmpty))
        }
    }
    
    static func handleWalletCreation(mnemonic: Mnemonic) -> Result<Wallet, Error> {
        let walletResult = CryptoService.createWallet(mnemonic: mnemonic)
        switch storeWalletOnCreation(walletResult: walletResult) {
            case .success(): return walletResult
            case .failure(let err): return .failure(err)
        }
    }
    
    static func storeWalletOnCreation(walletResult: Result<Wallet, Error>) -> Result<(), Error> {
        switch walletResult {
            case .success(let wallet):
                return StorageService.storeWalletDetails(wallet: wallet)
            case .failure(let err): return .failure(err)
        }
    }    
}
    
