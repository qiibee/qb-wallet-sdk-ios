//
//  StorageProvider.swift
//  WalletSDK
//
//  Created by Elvis on 05.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

internal protocol StorageProvider {
    static func walletAddress() -> Result<Address, Error>
    static func privateKey() -> Result<PrivateKey, Error>
    static func mnemonicPhrase() -> Result<Mnemonic, Error>
    static func storeWalletDetails(wallet: Wallet) -> Result<(), Error>
    static func removeWallet() -> Result<(), Error>
}

