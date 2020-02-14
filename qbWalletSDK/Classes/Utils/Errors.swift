//
//  Errors.swift
//  WalletSDK
//
//  Created by Elvis on 07.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation

public enum HTTPErrors: Error {
    case GetRequestFailed(message: String)
    case PostRequestFailed(message: String)
}

public enum JSONParseErrors: Error {
    case ParseTokensFailed
    case ParseBalancesFailed
    case ParseTransactionsFailed
    case ParseHashFailed
    case ParseRawTxFailed
    case ParseTokenFailed
}

public enum StorageErrors: Error {
    case MnemonicPhraseEmpty
    case PrivateKeyEmpty
    case WalletAddressEmpty
    case StoreWalletFailed
    case RemoveWalletFailed
}

public enum CryptoErrors: Error {
    case CreateMnemonicFailed
    case CreateWalletFailed
}

public enum ClientEntityErrors: Error {
    case InvalidMnemonicPhrase
    case InvalidWalletAddress
}
