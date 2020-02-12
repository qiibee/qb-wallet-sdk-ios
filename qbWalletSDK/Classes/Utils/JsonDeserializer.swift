import Foundation
import SwiftyJSON

class JsonDeserialization {
    private init() {}
    
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
                        return .failure(JSONParseErrors.ParseTokensFailed)
                    }
                    transactions.append(t)
                case .failure(let err): return .failure(err)
            }
        }
        
        return .success(transactions)
    }
    
    static func decodeToken(json: [String: JSON]) -> Result<Token, Error> {
        
        guard let symbol = json["symbol"]?.stringValue,
            let contractAddress = json[DecodeConstants.contractAddress]?.stringValue
        else {
            return .failure(JSONParseErrors.ParseTokensFailed)
        }
        
        guard let token = try? Token(
            symbol: symbol,
            balance: json["balance"]?.stringValue ?? "0",
            contractAddress: Address(address: contractAddress))
        else {
            return .failure(JSONParseErrors.ParseTokensFailed)
        }
        return .success(token)
    }
    
}

