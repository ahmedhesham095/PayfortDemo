//
//  PayfortApi.swift
//  PayFortDemo
//
//  Created by Holo Technology on 2/4/20.
//  Copyright © 2020 Holo Technology. All rights reserved.
//

import Foundation
import Moya
import CommonCrypto

enum PayfortApi {
    case getSdkToken(uuid:String)
}

extension PayfortApi: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL {
        return URL(string: "https://sbpaymentservices.payfort.com/")! //url to the backend
    }
    
    var path: String {
        switch self {
        case .getSdkToken:
            return "FortAPI/paymentApi"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSdkToken:
            return .post
            
        }
        
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getSdkToken(let uuid):
            return .requestParameters(parameters:
                ["access_code": "x0sN5ssSHzJh9FnIHPCV",
                               "device_id": uuid,
                               "language": "en",
                               "merchant_identifier": "872b7508",
                               "service_command": "SDK_TOKEN",
                               "signature": signature(uid: uuid)
                       ]
                
                , encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let headers = [
            "Content-Type": "application/json",
            "Accept-Language":"en"
        ]
        return headers
    }
    
    var authorizationType: AuthorizationType {
        return .none
    }
    
        var currency: String { return "SAR" }
        
        
        func signature(uid: String) -> String {
            return Encryption.sha256Hex(string: self.preSignature(uid)) ?? "Can't happen."
        }
        
    var shaRequest: String {
             return "$2y$10$I1mMOuD5Q"
         }
     
       var merchantId: String {
             return "872b7508"
     }
     
     var accessCode: String {
        return "x0sN5ssSHzJh9FnIHPCV"
     }
     
    
     func preSignature(_ uid: String) -> String {
            return self.shaRequest + "access_code=\(self.accessCode)" + "device_id=\(uid)" + "language=enmerchant_identifier=\(self.merchantId)" + "service_command=SDK_TOKEN\(self.shaRequest)"
        }
        

}


struct Encryption {
    static func sha256Hex(string: String) -> String? {
        guard let messageData = string.data(using: String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    static func ccSha256(data: Data) -> Data {
        var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digest.withUnsafeMutableBytes { (digestBytes) in
            data.withUnsafeBytes { (stringBytes) in
                CC_SHA256(stringBytes, CC_LONG(data.count), digestBytes)
            }
        }
        return digest
    }
}
