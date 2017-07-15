//
//  ObjectMapper.swift
//  bitcoin
//
//  Created by Filipe Santos Correa on 14.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ObjectMapper {
    
    func parseTickerData(json: Data) -> TickerData? {
        let decoder = JSONDecoder()
        
        do {
            let tickerData = try decoder.decode(TickerData.self, from: json)
            return tickerData
            
        } catch {
            return nil
            
        }
    }
    
}

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

