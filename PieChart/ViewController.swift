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
        colors: [.blue, .red, .green, .yellow, .purple],
        strokeWidth: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data: [String:Float] = [
            "apples": 103,
            "cherries": 94,
            "oranges": 75,
            "peaches": 88,
            "pears": 49,
        ]
        
        pieChart.set(data: data)
        
        view.addSubview(pieChart)
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pieChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalToConstant: 300).isActive = true
        pieChart.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
}

