
//
//  StorageService.swift
//  WalletSDK
//
//  Created by Elvis on 15.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//
import SwiftKeychainWrapper
import Foundation

final class StorageService: StorageProvider {
    private init() {}
    
    public static func mnemonicPhrase() -> Result<Mnemonic, Error> {
        guard let phrase = KeychainWrapper.standard.string(forKey: Constants.MNEMONIC_PHRASE) else {
            return .failure(StorageErrors.MnemonicPhraseEmpty)
        }
        do {
            return .success(try Mnemonic(phrase: phrase))
        } catch {
            return .failure(StorageErrors.MnemonicPhraseEmpty)
        }
        
    }
    
    public static func privateKey() -> Result<PrivateKey, Error> {
        guard let key = KeychainWrapper.standard.string(forKey: Constants.PRIVATE_KEY) else {
            return .failure(StorageErrors.PrivateKeyEmpty)
        }
        return .success(PrivateKey(privateKey: key))
    }
    
    public static func walletAddress() -> Result<Address, Error> {
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
    
    public static func storeWalletDetails(
        address: String,
        privateKey: String,
        mnemonic: String
        ) -> Result<(), Error> {
        let success1 = KeychainWrapper.standard.set(mnemonic, forKey: Constants.MNEMONIC_PHRASE)
        let success2 = KeychainWrapper.standard.set(privateKey, forKey: Constants.PRIVATE_KEY)
        let success3 = KeychainWrapper.standard.set(address, forKey: Constants.WALLET_ADDRESS)
        
        if (success1 == true && success2 == true && success3 == true) {
            return .success(())
        } else {
            return .failure(StorageErrors.StoreWalletFailed)
        }
    }
    
    public static func removeWallet() -> Result<(), Error> {
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
