//
//  ObjectMapper.swift
//  bitcoin
//
//  Created by Filipe Santos Correa on 14.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import Foundation

/// Converts data to swift objects, it maps the data to objects
class ObjectMapper {
    
    let decoder = JSONDecoder()
    
    /// Parses tickerData json data to an object of type TickerData
    ///
    /// - Parameter json: json data that should be converted to an object of type TickerData
    /// - Returns: an object of type TickerData if the data could be successfully converted, otherwise nil
    func parseTickerData(json: Data) -> TickerData? {
        do {
            let tickerData = try self.decoder.decode(TickerData.self, from: json)
            return tickerData
            
        } catch {
            return nil
            
        }
    }
    
    /// Parses historical json data to an object of type HistoricalData
    ///
    /// - Parameter json: json data that should be converted to an object of type [HistoricalData]
    /// - Returns: an array of type [HistoricalData] if the data could be successfully converted, otherwise nil
    func parseHistoricalData(json: Data) -> [HistoricalData]? {
        do {
            let historicalData = try self.decoder.decode([HistoricalData].self, from: json)
            return historicalData
            
        } catch {
            return nil
            
        }
    }
    
}


// MARK: - TickerData

struct TickerData: Codable {
    var last: Double
    var changes: Changes
}

struct Changes: Codable {
    var percent: Percent
}

struct Percent: Codable {
    var day: Double
}


// MARK: - HistoricalData

struct HistoricalData: Codable {
    var average: Double
    var time: Date
    
    private enum CodingKeys: String, CodingKey {
        case average
        case time
    }
}

extension HistoricalData {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let average = try values.decode(Double.self, forKey: .average)
        let dateString = try values.decode(String.self, forKey: .time)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = dateFormatter.date(from:dateString)!
        
        self.average = average
        self.time = time
    }
}

