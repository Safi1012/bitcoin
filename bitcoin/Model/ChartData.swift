//
//  ChartData
//  bitcoin
//
//  Created by Filipe Santos Correa on 15.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ChartData {
    
    var oneDayPriceHistory: [HistoricalData]?
    var oneMonthPriceHistory: [HistoricalData]?
    var allTimePriceHistory: [HistoricalData]?
    
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
