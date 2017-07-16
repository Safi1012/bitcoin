//
//  LineChartViewExtension.swift
//  bitcoin
//
//  Created by Filipe Santos Correa on 16.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import UIKit
import Charts

extension LineChartView {
    
    func drawBitcoinChar(historicalData: [HistoricalData], interval: Interval) {
        let formatter = DateFormatter()
        var dataEntries: [ChartDataEntry] = []
        var dates = [String]()
        
        switch interval {
        case .Day:
            formatter.dateFormat = "HH:mm"
        case .Month:
            formatter.dateFormat = "MM/dd"
        default:
            formatter.dateFormat = "yyyy/MM"
        }
        
        var position = 0.0
        
        // the "bitcoinaverage.com" API returns the historical data in descending order by time -> .reversed()
        for i in (0..<historicalData.count).reversed() {
            let dataEntry = ChartDataEntry(x: Double(position), y: historicalData[i].average)
            dataEntries.append(dataEntry)
            dates.append(formatter.string(from: historicalData[i].time))
            position += 1.0
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "")
        lineChartDataSet.setColor(UIColor.white)
        lineChartDataSet.mode = .horizontalBezier
        lineChartDataSet.lineWidth = 1.0
        lineChartDataSet.circleRadius = 0.0
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = true
        
        var dataSets = [IChartDataSet]()
        dataSets.append(lineChartDataSet)
        
        let lineChartData = LineChartData(dataSets: dataSets)
        
        self.animate(xAxisDuration: 1.0)
        self.xAxis.labelPosition = .bottom
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        self.xAxis.labelCount = 5
        self.xAxis.labelTextColor = UIColor.white
        self.rightAxis.enabled = false
        self.leftAxis.labelCount = 4
        self.leftAxis.labelTextColor = UIColor.white
        self.legend.enabled = false
        self.chartDescription = nil
        self.backgroundColor = UIColor.bitcoinBlue
        self.leftAxis.axisLineColor = UIColor.bitcoinBlue
        self.minOffset = 20.0
        self.data = lineChartData
    }
    
}

