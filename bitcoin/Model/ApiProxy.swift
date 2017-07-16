//
//  ApiProxy.swift
//  bitcoin
//
//  Created by Filipe Santos Correa on 14.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import Foundation
import Alamofire

/// Contains all the methods needed in this app to fetch data from the "bitcoinaverage.com" API
class ApiProxy {
    
    /// Fetches the Bitcoin ticker data - More information: https://apiv2.bitcoinaverage.com/#ticker-data-per-symbol
    ///
    /// - Parameters:
    ///   - success: returns TickerData if the data was fetched successfully from the API
    ///   - failure: returns an errorType if there was e.g. a network issue (no connection / timeout)
    func fetchTickerData(success: @escaping (TickerData) -> (), failure: @escaping (ErrorTypes) -> ()) {
        NetworkHandler().requestJSON(apiPath: "indices/global/ticker/BTCUSD", apiParameters: [:], success: { (json) in
            let tickerData = ObjectMapper().parseTickerData(json: json)
            tickerData != nil ? success(tickerData!) : failure(.ObjectParser)
            
        }) { (errorType) in
            failure(errorType)
            
        }
    }
    
    /// Fetches the historical Bitcoin data over a certain time period (1 day, 1 month, alltime) - More information: https://apiv2.bitcoinaverage.com/#historical-data
    ///
    /// - Parameters:
    ///   - interval: indicates the time period in (1 day, 1 month, alltime)
    ///   - success: returns the historical data for the passed time period, if the data was fetched successfully from the API
    ///   - failure: returns an errorType if there was e.g. a network issue (no connection / timeout)
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


/// Indicates a time interval
///
/// - Day: 1 day period
/// - Month: 1 month period
/// - Alltime: alltime period (since the beginning)
enum Interval: String {
    case Day     = "daily"
    case Month   = "monthly"
    case Alltime = "alltime"
}

