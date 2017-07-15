//
//  ApiProxy.swift
//  bitcoin
//
//  Created by Filipe Santos Correa on 14.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import Foundation
import Alamofire

class ApiProxy {
    
    func fetchTickerData(success: @escaping (TickerData) -> (), failure: @escaping (ErrorTypes) -> ()) {
        NetworkHandler().requestJSON(apiPath: "indices/global/ticker/BTCUSD", apiParameters: [:], success: { (json) in
            let tickerData = ObjectMapper().parseTickerData(json: json)
            tickerData != nil ? success(tickerData!) : failure(.objectParser)
            
        }) { (error) in
            failure(error)
            
        }
    }
    
}

