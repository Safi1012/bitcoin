//
//  ObjectMapper.swift
//  bitcoin
//
//  Created by Filipe Santos Correa on 14.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ObjectMapper {
    
    let decoder = JSONDecoder()
    
    func parseTickerData(json: Data) -> TickerData? {
        do {
            let tickerData = try self.decoder.decode(TickerData.self, from: json)
            return tickerData
            
        } catch {
            return nil
            
        }
    }
    
    func parseHistoricData(json: Data) -> [HistoricData]? {
        do {
            let historicData = try self.decoder.decode([HistoricData].self, from: json)
            return historicData
            
        } catch {
            return nil
            
        }
    }
    
}

// TickerData

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

// HistoricData

struct HistoricData: Codable {
    var average: Double
    var time: Date
    
    private enum CodingKeys: String, CodingKey {
        case average
        case time
    }
}

extension HistoricData {
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

