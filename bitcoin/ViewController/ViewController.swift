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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var chartData = ChartData()
    
    
    // MARK: - Liecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // clear default chart view message
        lineChartView.noDataText = ""
        lineChartView.noDataTextColor = UIColor.white
        
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
                self.trendIndicatorImageView.tintColor = UIColor.bitcoinGreen
            } else {
                self.trendIndicatorImageView.image = UIImage(named: "arrowDownSoftEdge")
                self.trendIndicatorImageView.tintColor = UIColor.bitcoinRed
            }
            
        }) { (error) in
            print(error.rawValue)
            
        }
    }
    
    func updateChartData(interval: Interval) {
        lineChartView.noDataText = ""
        lineChartView.clear()
        activityIndicator.startAnimating()
        let chartData = self.chartData.getChartDataForInterval(interval: interval)
        
        if chartData != nil {
            activityIndicator.stopAnimating()
            lineChartView.drawBitcoinChar(historicalData: chartData!, interval: interval)
            
        } else {
            ApiProxy().fetchHistoricalData(interval: interval, success: { (historicalData) in
                self.activityIndicator.stopAnimating()
                self.chartData.setChartDataForInterval(interval: interval, historicalData: historicalData)
                self.lineChartView.drawBitcoinChar(historicalData: historicalData, interval: interval)
                
            }) { (error) in
                self.activityIndicator.stopAnimating()
                self.lineChartView.noDataText = "Failed to load the chart data. \nPlease try again later."
                self.lineChartView.setNeedsDisplay()
                
            }
        }
    }
    
    func drawChart(historicalData: [HistoricalData], interval: Interval) {
        lineChartView.drawBitcoinChar(historicalData: historicalData, interval: interval)
    }
    
}


