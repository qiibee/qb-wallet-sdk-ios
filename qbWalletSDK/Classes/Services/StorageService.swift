
//
//  StorageService.swift
//  WalletSDK
//
//  Created by qiibee on 15.01.20.
//  Copyright © 2020 qiibee. All rights reserved.
//
import SwiftKeychainWrapper
import Foundation

internal final class StorageService: StorageProvider {
    private init() {}
    
    static func mnemonicPhrase() -> Result<Mnemonic, Error> {
        guard let phrase = KeychainWrapper.standard.string(forKey: Constants.MNEMONIC_PHRASE) else {
            return .failure(StorageErrors.MnemonicPhraseEmpty)
        }
        do {
            return .success(try Mnemonic(phrase: phrase))
        } catch {
            return .failure(StorageErrors.MnemonicPhraseEmpty)
        }
        
    }
    
    static func privateKey() -> Result<PrivateKey, Error> {
        guard let key = KeychainWrapper.standard.string(forKey: Constants.PRIVATE_KEY) else {
            return .failure(StorageErrors.PrivateKeyEmpty)
        }
        return .success(PrivateKey(privateKey: key))
    }
    
    static func walletAddress() -> Result<Address, Error> {
        guard let address = KeychainWrapper.standard.string(forKey: Constants.WALLET_ADDRESS) else {
            return .failure(StorageErrors.WalletAddressEmpty)
        }
        
        do {
            let newAddress = try Address(address: address)
            return .success(newAddress)
        } catch {
            return .failure(ClientEntityErrors.InvalidWalletAddress)
        }
    }
    
    static func storeWalletDetails(wallet: Wallet) -> Result<(), Error> {
        
        let success1 = KeychainWrapper.standard.set(wallet.mnemonic.phrase, forKey: Constants.MNEMONIC_PHRASE)
        let success2 = KeychainWrapper.standard.set(wallet.privateKey.privateKey, forKey: Constants.PRIVATE_KEY)
        let success3 = KeychainWrapper.standard.set(wallet.publicKey.address, forKey: Constants.WALLET_ADDRESS)
        
        if (success1 == true && success2 == true && success3 == true) {
            return .success(())
        } else {
            return .failure(StorageErrors.StoreWalletFailed)
        }
    }
    
    static func removeWallet() -> Result<(), Error> {
        let success1 = KeychainWrapper.standard.removeObject(forKey: Constants.MNEMONIC_PHRASE)
        let success2 = KeychainWrapper.standard.removeObject(forKey: Constants.PRIVATE_KEY)
        let success3 = KeychainWrapper.standard.removeObject(forKey: Constants.WALLET_ADDRESS)
        
        if (success1 == true && success2 == true && success3 == true) {
            return .success(())
        } else {
            return .failure(StorageErrors.RemoveWalletFailed)
        }
    }
}
