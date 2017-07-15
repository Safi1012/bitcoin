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
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var trendIndicatorImageView: UIImageView!
    @IBOutlet weak var oneDayPeriodButton: UIButton!
    @IBOutlet weak var oneMonthPeriodButton: UIButton!
    @IBOutlet weak var allTimePeriodButton: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var chartData = ChartData()
    
    
    // MARK: - Liecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1Day button is preselected
        oneDayPeriodButton.isSelected = true
        oneDayPeriodButton.tintColor = UIColor.white
        
        // fetch data and update UI
        updateBitcoinPrice()
        updateChartData(interval: .Day)
    }
    
    
    // MARK: - Actions
    
    @IBAction func oneDayButtonPressed(_ sender: UIButton) {
        updatedButtonState(button: sender)
        updateChartData(interval: .Day)
    }
    
    @IBAction func oneMounthButtonPressed(_ sender: UIButton) {
        updatedButtonState(button: sender)
        updateChartData(interval: .Month)
    }
    
    @IBAction func allTimeButtonPressed(_ sender: UIButton) {
        updatedButtonState(button: sender)
        updateChartData(interval: .Alltime)
    }
    
    
    // MARK: - Button UI
    
    func updatedButtonState(button: UIButton ) {
        resetButtonStates()
        selectButton(button: button)
    }
    
    func resetButtonStates() {
        oneDayPeriodButton.isSelected = false
        oneMonthPeriodButton.isSelected = false
        allTimePeriodButton.isSelected = false
    }
    
    func selectButton(button: UIButton) {
        button.isSelected = true
        button.tintColor = UIColor.white
    }
    
    
    // MARK: - Chart UI
    
    func updateBitcoinPrice() {
        ApiProxy().fetchTickerData(success: { (tickerData) in
            self.priceLabel.text = String(tickerData.last) + " $"
            
            if tickerData.changes.percent.day >= 0.0 {
                self.trendIndicatorImageView.image = UIImage(named: "arrowUpSoftEdge")
                self.trendIndicatorImageView.tintColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
            } else {
                self.trendIndicatorImageView.image = UIImage(named: "arrowDownSoftEdge")
                self.trendIndicatorImageView.tintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
            
        }) { (error) in
            print(error.rawValue)
            
        }
    }
    
    func updateChartData(interval: Interval) {
        let chartData = self.chartData.getChartDataForInterval(interval: interval)
        
        if chartData != nil {
            drawChart(historicData: chartData!, interval: interval)
        } else {
            ApiProxy().fetchHistoricData(interval: interval, success: { (historicData) in
                self.chartData.setChartDataForInterval(interval: interval, historicalData: historicData)
                self.drawChart(historicData: historicData, interval: interval)
                
            }) { (error) in
                print(error.rawValue)
            }
        }
    }
    
    func drawChart(historicData: [HistoricalData], interval: Interval) {
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
        for i in (0..<historicData.count).reversed() {
            let dataEntry = ChartDataEntry(x: Double(position), y: historicData[i].average)
            dataEntries.append(dataEntry)
            dates.append(formatter.string(from: historicData[i].time))
            position += 1.0
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


