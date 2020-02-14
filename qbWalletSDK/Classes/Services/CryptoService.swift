
//
//  CryptoService.swift
//  WalletSDK
//
//  Created by Elvis on 22.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation
import class HDWalletKit.Mnemonic
import struct HDWalletKit.PrivateKey

typealias HDMnemonic = HDWalletKit.Mnemonic
typealias HDPrivateKey = HDWalletKit.PrivateKey

internal final class CryptoService: CryptoProvider {
    
    private init() {}
    
    static func createMnemonic() -> Result<Mnemonic, Error> {
        do {
            let phrase = HDMnemonic.create()
            let mnemonic = try Mnemonic(phrase: phrase)
            return .success(mnemonic)
        } catch {
            return .failure(CryptoErrors.CreateMnemonicFailed)
        }
    }
    
    static func createWallet(mnemonic: Mnemonic) -> Result<Wallet, Error> {
        do {
            let pk = CryptoService.deriveWallet(mnemonic: mnemonic)
            let address = pk.publicKey.address
            
            return .success(Wallet(
                privateKey: pk.raw.dataToHexString(),
                publicKey: address,
                mnemonic: mnemonic.phrase
            ))
        } catch {
            return .failure(CryptoErrors.CreateWalletFailed)
        }
    }
    
    private static func deriveWallet(mnemonic: Mnemonic) -> HDPrivateKey {
        let seed = HDMnemonic.createSeed(mnemonic: mnemonic.phrase)
        let privateKey = HDPrivateKey(seed: seed, coin: .ethereum)
        
        // BIP32 key derivation
        // m/44'
        let purpose = privateKey.derived(at: .hardened(44))
        
        // m/44'/60'
        let coinType = purpose.derived(at: .hardened(60))
        
        // m/44'/60'/0'
        let account = coinType.derived(at: .hardened(0))
        
        // m/44'/60'/0'/0
        let change = account.derived(at: .notHardened(0))
        
        // m/44'/60'/0'/0/0
        let derivedPk = change.derived(at: .notHardened(0))
        
        return derivedPk
    }
}
