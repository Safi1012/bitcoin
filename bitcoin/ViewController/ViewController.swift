//
//  ViewController.swift
//  bitcoin
//
//  Created by Filipe Santos Correa on 14.07.17.
//  Copyright © 2017 Filipe Santos Correa. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonDay: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonDay.isSelected = true
        buttonDay.tintColor = UIColor.white
        
        self.imageView.image = UIImage(named: "arrowUpSoftEdge")
        self.imageView.tintColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        ApiProxy().fetchTickerData(success: { (tickerData) in
            print("\(tickerData)")
        }) { (error) in
            print(error.rawValue)
        }
        
        
        ApiProxy().fetchHistoricData(interval: .Day, success: { (historicData) in
            self.setChart(historicData: historicData)
            
        }) { (error) in
            print(error.rawValue)
        }
        
    }
    
    func setChart(historicData: [HistoricData]) {
        var dataEntries: [ChartDataEntry] = []
        var dates = [String]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        var a = 0.0
        
        for i in (0..<historicData.count).reversed() {
            let dataEntry = ChartDataEntry(x: Double(a), y: historicData[i].average)
            dataEntries.append(dataEntry)
            dates.append(formatter.string(from: historicData[i].time))
            a += 1.0
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "")
        lineChartDataSet.setColor(UIColor.white)
        lineChartDataSet.mode = .horizontalBezier
        lineChartDataSet.lineWidth = 1.0
        lineChartDataSet.circleRadius = 0.0
        lineChartDataSet.highlightColor = UIColor.red
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = true
        
        var dataSets = [IChartDataSet]()
        dataSets.append(lineChartDataSet)
        
        let lineChartData = LineChartData(dataSets: dataSets)
        
        lineChartView.data = lineChartData
        lineChartView.animate(xAxisDuration: 1.5)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        lineChartView.xAxis.labelCount = 5
        lineChartView.xAxis.labelTextColor = UIColor.white
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.labelCount = 4
        lineChartView.leftAxis.labelTextColor = UIColor.white
        lineChartView.legend.enabled = false
        lineChartView.chartDescription = nil
        lineChartView.backgroundColor = UIColor(red: 39/255, green: 108/255, blue: 186/255, alpha: 1.0)
        lineChartView.leftAxis.axisLineColor = UIColor(red: 39/255, green: 108/255, blue: 186/255, alpha: 1.0)
        lineChartView.minOffset = 20.0
    }
    
}


