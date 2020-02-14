//
//  ApiService.swift
//  WalletSDK
//
//  Created by Elvis on 05.01.20.
//  Copyright © 2020 Elvis. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

internal final class ApiService: HttpClient {
    private init() {}
    
    private static let QB_API = "https://api.qiibee.com"
    private static let QB_APP_API = "\(QB_API)/app"
    
    static func getBalances(
        address: Address,
        responseHandler: @escaping (Result<TokenBalances, Error>) -> ()
        ) {
        AF.request(
            "\(ApiService.QB_APP_API)/addresses/\(address.address)",
            parameters: ["public": "true"]
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    responseHandler(
                        JsonDeserialization.decodeBalances(json: JSON(value))
                    )
                case .failure(let error):
                    responseHandler(
                        .failure(
                            HTTPErrors.GetRequestFailed(message:
                                error.errorDescription ?? "Get balances failed"
                            )
                        )
                    )
                }
        }
    }
    
    public static func getTokens(
        address: Address,
        responseHandler: @escaping (Result<Tokens, Error>) -> ()
        ) {
        AF.request(
            "\(ApiService.QB_API)/tokens",
            parameters: ["public": "true", "walletAddress": address.address]
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    responseHandler(
                        JsonDeserialization.decodeToknes(json: JSON(value))
                    )
                case .failure(let error):
                    responseHandler(
                        .failure(
                            HTTPErrors.GetRequestFailed(message:
                                error.errorDescription ?? "Get tokens failed"
                            )
                        )
                    )
                }
        }
    }
    
    static func getTransactions(
        address: Address,
        responseHandler: @escaping (Result<Array<Transaction>, Error>) -> ()
        ) {
        AF.request(
            "\(ApiService.QB_API)/transactions/\(address.address)/history"
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    responseHandler(JsonDeserialization.decodeTransactions(json: JSON(value))
                    )
                case .failure(let error):
                    responseHandler(
                        .failure(
                            HTTPErrors.GetRequestFailed(message:
                                error.errorDescription ?? "Get transactions failed"
                            )
                        )
                    )
                }
        }
    }
    
    static func sendSignedTransaction(
        signedTx: String,
        responseHandler: @escaping (Result<String, Error>) -> ()
        ) {
        AF.request(
            "\(ApiService.QB_API)/transactions",
            method: .post,
            parameters: ["data": signedTx],
            encoder: URLEncodedFormParameterEncoder.default
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let json = value as! Data
                        let hash = try JSONDecoder().decode(String.self, from: json)
                        responseHandler(.success(hash))
                    } catch {
                        responseHandler(.failure(JSONParseErrors.ParseHashFailed))
                    }
                case .failure(let error):
                    responseHandler(
                        .failure(
                            HTTPErrors.PostRequestFailed(message:
                                error.errorDescription ?? "Get transactions failed"
                            )
                        )
                    )
                }
        }
    }
    
    static func getRawTransaction(
        fromAddress: Address,
        toAddress: Address,
        contractAddress: Address,
        sendTokenValue: Decimal,
        responseHandler: @escaping (Result<String, Error>) -> ()
        ) {
        
        let weiValue = "\(sendTokenValue * 1000000000000000000)"
        
        AF.request(
            "\(ApiService.QB_API)/transactions/raw",
            parameters: [
                "from": fromAddress.address,
                "to": toAddress.address,
                "contractAddress": contractAddress.address,
                "transferAmount": weiValue
            ]
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    responseHandler(
                        JsonDeserialization.decodeRawTransaction(json: JSON(value), weiValue: weiValue)
                    )
                case .failure(let error):
                    responseHandler(
                        .failure(
                            HTTPErrors.GetRequestFailed(message:
                                error.errorDescription ?? "Get raw transaction failed"
                            )
                        )
                    )
                }
        }
    }
    
    
}
