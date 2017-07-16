//
//  NetworkHandler.swift
//  bitcoin
//
//  Created by Filipe Santos Correa on 14.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import Foundation
import Alamofire

/// Handles the network connection, the actual request to the API is made here
class NetworkHandler {
    
    /// Requests json data from a given site
    ///
    /// - Parameters:
    ///   - apiPath: the api path of the site (e.g. "indices/global/ticker/BTCUSD")
    ///   - apiParameters: the api parameters (e.g. "&"period=alltime")
    ///   - success: returns the successfully fetched api data
    ///   - failure: returns an errorType if there was an network issue
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


/// Contains all ErrorTypes of this application, this enum can easily be extended to support more ErrorTypes
///
/// - Network: a string indicating that there was a network failure
/// - ObjectParser: a string indicating that there was an issue while converting (unwrapping) the fetched data to swift objects
enum ErrorTypes: String {
    case Network        = "Network failure"
    case ObjectParser   = "Error unwrapping the requested data"
}
