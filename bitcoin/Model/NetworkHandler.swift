//
//  NetworkHandler.swift
//  bitcoin
//
//  Created by Filipe Santos Correa on 14.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHandler {
    
    func requestJSON(apiPath: String, apiParameters: [String:String], success: @escaping (Data) -> (), failure: @escaping (ErrorTypes) -> () ) {
        Alamofire.request("https://apiv2.bitcoinaverage.com/\(apiPath)", parameters: apiParameters)
            .responseData { response in
                switch response.result {
                case .success:
                    success(response.result.value!)
                    
                default:
                    failure(.Network)
                }
            }
    }

}

enum ErrorTypes: String {
    case Network        = "Network failure"
    case ObjectParser   = "Error unwrapping the requested data"
}
