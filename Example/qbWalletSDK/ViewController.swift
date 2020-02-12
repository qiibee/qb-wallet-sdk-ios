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
        
        let walletAddress = "0xbBf0458e845E1fd7EEfAd6d5689b13A3E3312510"
        let mnemo = try! Mnemonic(phrase: "payment under burden bus short process film book crazy uniform hair mercy")
        
        let res = Wallet.getWalletAddress()
        log(value: "result is")
        log(value: res)
        Wallet.getBalances()
        
    }
    
    func log(value: String) {
        os_log("LOG: %s", log: OSLog.myLogs, type: .info, value)
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
        CryptoWallet.getTokens(responseHandler: { result in
          switch result {
          case .success(let transactions): log(value: "\(transactions.count)")
          case .failure(let err): log(value: "\(err)")
            }
        })
    }
    
    static func log(value: String) {
        os_log("LOG: %s", log: OSLog.myLogs, type: .info, value)
    }
}

