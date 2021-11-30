//
//  ViewController.swift
//  PieChart
//
//  Created by Engin KUK on 25.11.2021.
//

import UIKit

class ViewController: UIViewController
{
    let chart = VerticalChart(
        frame: CGRect(x: 0, y:0, width: 100, height: 15),
        colors: [.yellow, .red, .orange, .brown, .purple, .gray, .lightGray, .blue],
        strokeWidth: 0)
    
    let scrollView: UIScrollView = {
         let v = UIScrollView()
         v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray.withAlphaComponent(0.25)
         return v
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        let seriesPoints0: [AxisData] = [
            AxisData(index: 0, label: "apples", value: 25),
            AxisData(index: 1, label: "cherries", value: 45),
            AxisData(index: 2, label: "oranges", value: 40),
            AxisData(index: 3, label: "peaches", value: 25),
            AxisData(index: 4, label: "pears", value: 50),
            AxisData(index: 4, label: "banana", value: 70),
            AxisData(index: 4, label: "nuts", value: 100),
            AxisData(index: 4, label: "flowers", value: 50),
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
 
        chart.set(dataSet: [dataSet0])

        
        // add the scroll view to self.view
        self.view.addSubview(scrollView)

        // constrain the scroll view to 8-pts on each side
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150.0).isActive = true

        // add labelOne to the scroll view
        scrollView.addSubview(chart)
 
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8.0).isActive = true
        chart.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8.0).isActive = true
        chart.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -8.0).isActive = true
        chart.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8.0).isActive = true
        chart.widthAnchor.constraint(equalToConstant: 450).isActive = true
        chart.heightAnchor.constraint(equalToConstant: 350).isActive = true
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
 
