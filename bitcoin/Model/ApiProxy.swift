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
            tickerData != nil ? success(tickerData!) : failure(.ObjectParser)
            
        }) { (errorType) in
            failure(errorType)
            
        }
    }
    
    func fetchHistoricalData(interval: Interval, success: @escaping ([HistoricalData]) -> (), failure: @escaping (ErrorTypes) -> ()) {
        let apiParameters = ["period": interval.rawValue]
        
        NetworkHandler().requestJSON(apiPath: "indices/global/history/BTCUSD", apiParameters: apiParameters, success: { (json) in
            let historicalData = ObjectMapper().parseHistoricalData(json: json)
            historicalData != nil ? success(historicalData!) : failure(.ObjectParser)
            
        }) { (errorType) in
            failure(errorType)
            
        }
    }
    
}

enum Interval: String {
    case Day     = "daily"
    case Month   = "monthly"
    case Alltime = "alltime"
}

