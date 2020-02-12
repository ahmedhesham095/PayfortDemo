//
//  PayfortService.swift
//  PayFortDemo
//
//  Created by Holo Technology on 2/4/20.
//  Copyright © 2020 Holo Technology. All rights reserved.
//

import Moya

class PayfortSevice {
    static func requestSdkToken( uuid : String ,callback:@escaping (String?) -> Void) {
        let provider = MoyaProvider<PayfortApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
        provider.request(.getSdkToken(uuid: uuid)) { result in
            switch result {
            case let .success(response):
                do {
                    if let dict = try response.mapJSON() as? [String : Any] {
                        if let status = dict["sdk_token"] as? String {
                            print(status)

                            callback(status)
                        }
                    }
                    
                    callback("")
                } catch {
                    callback( "Internal Server Error")
                }
            case .failure(_):
                callback( "No Internet Connection")
            }
        }
    }
}
