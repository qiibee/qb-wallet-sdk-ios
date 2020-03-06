//
//  CryptoProvider.swift
//  WalletSDK
//
//  Created by qiibee on 05.01.20.
//  Copyright © 2020 qiibee. All rights reserved.
//

import Foundation

internal protocol CryptoProvider {
    static func createMnemonic() -> Result<Mnemonic, Error>
    static func createWallet(mnemonic: Mnemonic) -> Result<Wallet, Error>    
}
