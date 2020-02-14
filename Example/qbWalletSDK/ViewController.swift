//
//  ViewController.swift
//  qbWalletSDK
//
//  Created by qbxelvis on 01/30/2020.
//  Copyright (c) 2020 qbxelvis. All rights reserved.
//

import UIKit
import qbWalletSDK
import os

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let myLogs = OSLog(subsystem: subsystem, category: "myLogs")
}

class Wallet {
    static func getWalletAddress() -> String {
        switch CryptoWallet.walletAddress()  {
            case .success(let address): return address.address
            case .failure(let error): return "\(error)"
        }
    }
    
    static func getPrivateKey() -> String {
        switch CryptoWallet.privateKey()  {
            case .success(let privateKey): return privateKey.privateKey
            case .failure(let error): return "\(error)"
        }
    }
    
    static func getMnemonicPhrase() -> String {
        switch CryptoWallet.mnemonicPhrase() {
            case .success(let mnemonic): return mnemonic.phrase
            case .failure(let error): return "\(error)"
        }
    }
    
    static func createWallet() -> String {
        switch CryptoWallet.createWallet() {
            case .success(let wallet): return "\(wallet.mnemonic) \(wallet.publicKey) "
            case .failure(let err): return "\(err)"
        }
    }
    
    static func removeWallet() -> String {
        switch CryptoWallet.removeWallet() {
            case .success(): return "WALLET DELETED"
            case .failure(let err): return "\(err)"
        }
    }
    
    static func restoreWallet(mnemonic: Mnemonic) -> String {
        switch CryptoWallet.restoreWallet(mnemonic: mnemonic) {
            case .success(let wallet): return "\(wallet.mnemonic)"
            case .failure(let err): return "\(err)"
        }
    }
    
    static func getBalances() {
        CryptoWallet.getBalances(responseHandler: { result in
          switch result {
          case .success(let balances): log(value: "\(balances.balances.privateTokens.count)")
          case .failure(let err): log(value: "\(err)")
            }
        })
    }
    
    static func sendTransaction() {
        CryptoWallet.sendTransaction(
            toAddress: try! Address(address: "0xbBf0458e845E1fd7EEfAd6d5689b13A3E3312510"),
            contractAddress: try! Address(address: "0xf2e71f41e670c2823684ac3dbdf48166084e5af3"),
            sendTokenValue: 1.1,
            responseHandler: { result in
                switch result {
                    case .success(let raw): log(value: "\(raw)")
                    case .failure(let err): log(value: "\(err)")
                }
                
            }
        )
    }
    
    static func log(value: String) {
        os_log("LOG: %s", log: OSLog.myLogs, type: .info, value)
    }
}

