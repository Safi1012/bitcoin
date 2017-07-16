//
//  ChartData
//  bitcoin
//
//  Created by Filipe Santos Correa on 15.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import Foundation

/// ChartData, stores the data locally to prevent overfetching -> data could be saved later to coreData / Realm to make the app offline capable
class ChartData {
    
    var oneDayPriceHistory: [HistoricalData]?
    var oneMonthPriceHistory: [HistoricalData]?
    var allTimePriceHistory: [HistoricalData]?
    
    /// Stores the given historicalData to a local variable
    ///
    /// - Parameters:
    ///   - interval: indicates the time period in (1 day, 1 month, alltime)
    ///   - historicalData: contains Bitcoin data (such as price and time) over a certain time interval
    func setChartDataForInterval(interval: Interval, historicalData: [HistoricalData]) {
        switch interval {
        case .Day:
            self.oneDayPriceHistory = historicalData
        case .Month:
            self.oneMonthPriceHistory = historicalData
        case .Alltime:
            self.allTimePriceHistory = historicalData
        }
    }
    
    /// Returns the locally stored historicalData from a given time interval
    ///
    /// - Parameter interval: indicates the time period in (1 day, 1 month, alltime)
    /// - Returns: an array of historicalData that contains Bitcoin data (such as price and time) over the given time interval
    func getChartDataForInterval(interval: Interval) -> [HistoricalData]? {
        switch interval {
        case .Day:
            return self.oneDayPriceHistory != nil ? self.oneDayPriceHistory : nil
        case .Month:
            return self.oneMonthPriceHistory != nil ? self.oneMonthPriceHistory : nil
        case .Alltime:
            return self.allTimePriceHistory != nil ? self.allTimePriceHistory : nil
        }
    }
    
}
