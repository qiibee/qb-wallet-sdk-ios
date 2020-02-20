//
//  CryptoWallet.swift
//  WalletSDK
//
//  Created by qiibee on 23.12.19.
//  Copyright © 2019 qiibee. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

final public class CryptoWallet: SDKProvider {
    
    private init() {}

    /**
        Get stored Wallet Address

        - Returns: Result of currently stored Wallet Address or Error<WalletAddressEmpty>
    */
    
    public static func walletAddress() -> Result<Address, Error> {
         StorageService.walletAddress()
    }

    /**
        Get stored Private Key

        - Returns: Result of currently stored Private Key or Error<PrivateKeyEmpty>
    */
    public static func privateKey() -> Result<PrivateKey, Error> {
        StorageService.privateKey()
    }


    /**
        Get stored Mnemonic Phrase

        - Returns: Result of currently stored Mnemonic Phrase or Error
    */
    public static func mnemonicPhrase() -> Result<Mnemonic, Error> {
        StorageService.mnemonicPhrase()
    }

    /**
        Create new Wallet

        - Returns: Result of newly created Wallet or Error
    */
    public static func createWallet() -> Result<Wallet, Error> {
        switch CryptoService.createMnemonic() {
            case .success(let mnemonic):
                return handleWalletCreation(mnemonic: mnemonic)
            case .failure(let error):
                return .failure(error)
        }
    }

    /**
        Restore existing Wallet

        - Returns: Result of existing Wallet or Error
    */
    public static func restoreWallet(mnemonic: Mnemonic) -> Result<Wallet, Error> {
        handleWalletCreation(mnemonic: mnemonic)
    }

    /**
        Remove currently stored Wallet

        - Returns: Result of () on success, or Error
    */
    public static func removeWallet() -> Result<(), Error> {
        StorageService.removeWallet()
    }

    /**
        Gets current balances and passes

        - Parameters:
            - @escaping (Result<TokenBalances, Error>) -> ()
    */
    public static func getBalances(
        responseHandler: @escaping (Result<TokenBalances, Error>) -> ()
    ) -> () {
        switch StorageService.walletAddress() {
            case .success(let address):
                ApiService.getBalances(address: address, responseHandler: responseHandler)
            case .failure(let err): responseHandler(.failure(err))
        }
        
    }


    /**
        Gets current tokens

        - Parameters: 
            - @escaping (Result<Tokens, Error>) -> ()
    */
    public static func getTokens(
        responseHandler: @escaping (Result<Tokens, Error>) -> ()
    ) -> () {
        switch StorageService.walletAddress() {
            case .success(let address):
                ApiService.getTokens(address: address, responseHandler: responseHandler)
            case .failure(let err): responseHandler(.failure(err))
        }
    }

    
    /**
        Gets current transactions

        - Parameters: 
            - @escaping (Result<Array<Transaction>, Error>) -> ()
    */
    public static func getTransactions(
        responseHandler: @escaping (Result<Array<Transaction>, Error>) -> ()
    ) -> () {
        switch StorageService.walletAddress() {
            case .success(let address):
                ApiService.getTransactions(address: address, responseHandler: responseHandler)
            case .failure(let err): responseHandler(.failure(err))
        }
    }
    
    
    /**
        Performs send transaction

        - Parameters: 
            - toAddress: Address,
            - contractAddress: Address, 
            - sendTokenValue: Double,
            - responseHandler: @escaping (Result<Hash, Error>) -> ()
    */
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

     /**
        - Parameters: 
            - toAddress: Address,
            - contractAddress: Address, 
            - sendTokenValue: Double,
            - responseHandler: @escaping (Result<String, Error>) -> ()
    */
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
    
