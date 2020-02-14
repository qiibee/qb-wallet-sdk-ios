import Foundation
import SwiftyJSON
import HDWalletKit

internal final class JsonDeserialization {
    private init() {}
    
    static func decodeBalances(json: JSON) -> Result<TokenBalances, Error> {
        
        let data = json.dictionaryValue
        
        guard let USD = data["aggregateValue"]?["USD"].stringValue,
            let balances = data["balances"]?.dictionaryValue,
            let transactionCount = data["transactionCount"]?.numberValue else {
                return .failure(JSONParseErrors.ParseBalancesFailed)
        }
        
        guard let publicTokensData = balances["public"]?.dictionaryValue,
            let privateTokensData = balances["private"]?.dictionaryValue else {
                return .failure(JSONParseErrors.ParseBalancesFailed)
        }
        
        var privateTokens: [Token] = []
        var publicTokens: [Token] = []
        var ethBalance = "0"
        
        for (key, value) in publicTokensData {
            if (key == Constants.ETH) {
                guard let tempEth = value.dictionaryValue["balance"]?.stringValue else {
                    return .failure(JSONParseErrors.ParseBalancesFailed)
                }
                ethBalance = tempEth
                
            } else {
                switch decodeTokenFromBalances(symbol: key, data: value.dictionaryValue) {
                    case .success(let token): publicTokens.append(token)
                    case .failure(let err): return .failure(err)
                }
            }
        }
        
        for (key, value) in privateTokensData {
            switch decodeTokenFromBalances(symbol: key, data: value.dictionaryValue) {
                case .success(let token): privateTokens.append(token)
                case .failure(let err): return .failure(err)
            }
        }
        
        return .success(
            TokenBalances(
                transactionCount: Int(truncating: transactionCount),
                balances: Balances(
                    privateTokens: privateTokens,
                    publicTokens: publicTokens,
                    ethBalance: ETHBalance(balance: ethBalance)
                ),
                aggValue: AggregateValue(USD: USD)
            )
        )
    }
    
    static func decodeToknes(json: JSON) -> Result<Tokens, Error> {
        let data = json.dictionaryValue
        
        guard let privateTokensData = data["private"]?.arrayValue,
            let publicToknesData = data["public"]?.arrayValue else {
                return .failure(JSONParseErrors.ParseTokensFailed)
        }
        
        var privateTokens: [Token] = []
        var publicTokens: [Token] = []
        
        for tokenData in privateTokensData {
            switch decodeToken(json: tokenData.dictionaryValue) {
                case .success(let token): privateTokens.append(token)
                case .failure(let err): return .failure(err)
            }
        }
        
        
        for tokenData in publicToknesData {
            switch decodeToken(json: tokenData.dictionaryValue) {
                case .success(let token): publicTokens.append(token)
                case .failure(let err): return .failure(err)
            }
        }
        
        return .success(Tokens(privateTokens: privateTokens, publicTokens: publicTokens))
    }
    
    static func decodeRawTransaction(json: JSON, privateKey: PrivateKey) -> Result<String, Error> {
        let data = json.dictionaryValue
        
        guard let txData = (data["data"]?.stringValue),
            let nonce = data["nonce"]?.stringValue,
            let value = data["value"]?.stringValue,
            let chainId = data["chainId"]?.int,
            let gasPrice = data["gasPrice"]?.stringValue,
            let to = data["to"]?.stringValue,
            let gasLimit = data["gasLimit"]?.stringValue else {
            return .failure(JSONParseErrors.ParseRawTxFailed)
        }
        
        let signer = EIP155Signer(chainId: chainId)
        let fGasPrice = hexToInt(value: gasPrice)
        let fGasLimit = hexToInt(value: gasLimit)
        let fNonce = hexToInt(value: nonce)
        let fValue = hexToInt(value: value)
        
        let rawTransaction = EthereumRawTransaction(
            value: Wei(fValue),
            to: to,
            gasPrice: fGasPrice,
            gasLimit: fGasLimit,
            nonce: fNonce,
            data: Data(hex: txData)
        )
        
        guard let pk = HDPrivateKey(pk: privateKey.privateKey, coin: .ethereum) else {
            return .failure(JSONParseErrors.ParseRawTxFailed)
        }
        
        guard let signed = try? signer.sign(
            rawTransaction,
            privateKey: pk
        ).toHexString() else {
            return .failure(JSONParseErrors.ParseRawTxFailed)
        }
        
        return .success("0x" + signed)
    }
    
    static func decodeTransactions(json: JSON) -> Result<[Transaction], Error> {
        let data = json.arrayValue
        var transactions: [Transaction] = []
        
        for txData in data {
            let dict = txData.dictionaryValue
            
            guard let from = dict["from"]?.stringValue,
                let to = dict["to"]?.stringValue,
                let contractAddress = dict["contractAddress"]?.stringValue,
                let timestamp = dict["timestamp"]?.numberValue,
                let token = dict["token"]?.dictionary else {
                    return .failure(JSONParseErrors.ParseTransactionsFailed)
            }
            
            switch decodeToken(json: token) {
                case .success(let t):
                    guard let t = try?
                        Transaction(
                            to: Address(address: to),
                            from: Address(address: from),
                            contractAddress: Address(address: contractAddress),
                            timestamp: TimeInterval(truncating: timestamp),
                            token: t)
                    else {
                        return .failure(JSONParseErrors.ParseTokenFailed)
                    }
                    transactions.append(t)
                case .failure(let err): return .failure(err)
            }
        }
        
        return .success(transactions)
    }
    
    static func decodeSendTxResponse(json: JSON) -> Result<Hash, Error> {
        let data = json.dictionaryValue
        
        guard let hash = data["hash"]?.stringValue else {
            return .failure(JSONParseErrors.ParseSendTxResponseFailed)
        }
        
        return .success(Hash(hash: hash))
    }
    
    private static func decodeToken(json: [String: JSON]) -> Result<Token, Error> {
        
        guard let symbol = json["symbol"]?.stringValue,
            let contractAddress = json["contractAddress"]?.stringValue else {
            return .failure(JSONParseErrors.ParseTokenFailed)
        }
        
        guard let token = try? Token(
            symbol: symbol,
            balance: json["balance"]?.stringValue ?? "0",
            contractAddress: Address(address: contractAddress)) else {
            return .failure(JSONParseErrors.ParseTokenFailed)
        }
        return .success(token)
    }
    
    private static func decodeTokenFromBalances(symbol: String, data: [String:JSON]) -> Result<Token, Error> {
        guard let balance = data["balance"]?.stringValue,
            let contractAddress = data["contractAddress"]?.stringValue else {
                return .failure(JSONParseErrors.ParseBalancesFailed)
        }
                    
        guard let token = try? Token(
            symbol: symbol,
            balance: balance,
            contractAddress: Address(address: contractAddress)
        ) else {
            return .failure(JSONParseErrors.ParseBalancesFailed)
        }
        
        return .success(token)
    }
    
    private static func hexToInt(value: String) -> Int {
        Int(value.stripHexPrefix(), radix: 16) ?? 0
    }
    
}

