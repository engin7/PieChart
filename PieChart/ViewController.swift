//
//  ViewController.swift
//  PieChart
//
//  Created by Engin KUK on 25.11.2021.
//

import UIKit

class ViewController: UIViewController
{
    let pieChart = VerticalChart(
        frame: CGRect(x: 0, y:0, width: 100, height: 15),
        colors: [.yellow, .red, .orange, .brown, .purple],
        strokeWidth: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        let seriesPoints0: [AxisData] = [
            AxisData(index: 0, label: "apples", value: 25),
            AxisData(index: 1, label: "cherries", value: 45),
            AxisData(index: 2, label: "oranges", value: 40),
            AxisData(index: 3, label: "peaches", value: 25),
            AxisData(index: 4, label: "pears", value: 50)
        ]
         
        let seriesPoints1: [AxisData] = [
            AxisData(index: 0, label: "apples", value: 15),
            AxisData(index: 1, label: "cherries", value: 35),
            AxisData(index: 2, label: "oranges", value: 20),
            AxisData(index: 3, label: "peaches", value: 55),
            AxisData(index: 4, label: "pears", value: 50)
        ]
        
        let dataSet0: SeriesDataSet = SeriesDataSet(seriesName: "Farm I", seriesPoints: seriesPoints0)
        let dataSet1: SeriesDataSet = SeriesDataSet(seriesName: "Farm II", seriesPoints: seriesPoints1)
 
        
        pieChart.set(dataSet: [dataSet0])
        
        view.addSubview(pieChart)
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pieChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalToConstant: 350).isActive = true
        pieChart.heightAnchor.constraint(equalToConstant: 350).isActive = true
    }
}


///
enum GraphEnum {
    case Pie
    case Vertical
    case Horizontal
    case VerticalGrouped
    case HorizontalGrouped
    case VerticalStacked
    case HorizontalStacked
}

struct ChartDataSet {
    let ChartType: GraphEnum
    let data: [SeriesDataSet]
    // colorPallette ?
}
 
struct SeriesDataSet {
    let seriesName: String
    let seriesPoints: [AxisData]
}

struct AxisData {
    let index: Int
    let label: String
    let value: Double
}
 
