//
//  ViewController.swift
//  PieChart
//
//  Created by Engin KUK on 25.11.2021.
//

import UIKit

class ViewController: UIViewController
{
    let pieChart = PieChartView(
        frame: CGRect(x: 0, y:0, width: 100, height: 15),
        colors: [.yellow, .red, .orange, .brown, .purple],
        strokeWidth: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let seriesPoints: [AxisData] = [
            AxisData(index: 0, label: "apples", value: 200),
            AxisData(index: 1, label: "cherries", value: 100),
            AxisData(index: 2, label: "oranges", value: 50),
            AxisData(index: 3, label: "peaches", value: 120),
            AxisData(index: 4, label: "pears", value: 10)
        ]
         
        let dataSet: SeriesDataSet = SeriesDataSet(seriesName: "Fruits in inventory", seriesPoints: seriesPoints)
        
       
        pieChart.set(data: dataSet)
        
        view.addSubview(pieChart)
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pieChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalToConstant: 300).isActive = true
        pieChart.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
}


struct SeriesDataSet {
    let seriesName: String
    let seriesPoints: [AxisData]
}


struct AxisData {
    let index: Int
    let label: String
    let value: CGFloat
}
