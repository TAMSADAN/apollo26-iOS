//
//  CandleChartView.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/11.
//

import UIKit
import Charts
import Then

class CandleChartView: UIView {
    var candleChartView = LineChartView()
    
    var coinCharts: [ProductOhlc]!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    func update(coinCharts: [ProductOhlc]) {
        self.coinCharts = coinCharts
        setChart(coinCharts: coinCharts, range: 10)
    }
    
    
}

extension CandleChartView {
    func setChart(coinCharts: [ProductOhlc], range: Int) {
        var dataEntries: [CandleChartDataEntry] = []
        for (i, coinChart) in coinCharts.enumerated() {
            let mult = range + 1
            let val = 30.0
            let high = coinChart.high
            let low = coinChart.low
            let open = coinChart.open
            let close = coinChart.close
            let even = i % 2 == 0
            
            let dataEntry = CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close)
            
            dataEntries.append(dataEntry)
        }
        let chartDataSet = CandleChartDataSet(entries: dataEntries, label: "")
        chartDataSet.axisDependency = .left
        chartDataSet.setColor(UIColor(white: 80/255, alpha: 1))
        chartDataSet.drawIconsEnabled = false
        chartDataSet.shadowColor = .darkGray
        chartDataSet.shadowWidth = 0.7
        chartDataSet.decreasingColor = .red
        chartDataSet.decreasingFilled = true
        chartDataSet.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        chartDataSet.increasingFilled = false
        chartDataSet.neutralColor = .blue
        let chartData = CandleChartData(dataSet: chartDataSet)
        
        candleChartView.data = chartData
    }
    
    func setView() {
        candleChartView.chartDescription.enabled = false

        candleChartView.dragEnabled = true
        candleChartView.setScaleEnabled(true)
        candleChartView.maxVisibleCount = 200
        candleChartView.pinchZoomEnabled = false

        candleChartView.legend.horizontalAlignment = .right
        candleChartView.legend.verticalAlignment = .top
        candleChartView.legend.orientation = .vertical
        candleChartView.legend.drawInside = true
        candleChartView.legend.font = Const.Font.caption1

        candleChartView.leftAxis.labelFont = Const.Font.caption1
        candleChartView.leftAxis.spaceTop = 0.3
        candleChartView.leftAxis.spaceBottom = 0.3
        candleChartView.leftAxis.axisMinimum = 0

        candleChartView.rightAxis.enabled = false

        candleChartView.xAxis.labelPosition = .bottom
        candleChartView.xAxis.labelFont = Const.Font.caption2
        
        addSubview(candleChartView)
        
        candleChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            candleChartView.topAnchor.constraint(equalTo: topAnchor),
            candleChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            candleChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            candleChartView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
