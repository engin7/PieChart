//
//  ViewController.swift
//  PieChart
//
//  Created by Engin KUK on 25.11.2021.
//

import UIKit

class ViewController: UIViewController
{
    let chart = HorizontalChart(
        frame: CGRect(x: 0, y:0, width: 100, height: 15),
        colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue],
        strokeWidth: 0)
    
    let scrollView: UIScrollView = {
         let v = UIScrollView()
         v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray.withAlphaComponent(0.2)
        v.bounces = false
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
 
        chart.set(dataSet: [dataSet0], presentingVC: self)

        
        // add the scroll view to self.view
        self.view.addSubview(scrollView)

        // constrain the scroll view to 8-pts on each side
        if chart is HorizontalChart {
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        } else {
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        }
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160.0).isActive = true

        // add labelOne to the scroll view
        scrollView.addSubview(chart)
 
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        chart.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        chart.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        chart.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        chart.widthAnchor.constraint(equalToConstant: 320).isActive = true
        chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
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
 


// Global Methods

func roundToNumber(_ x : Double, roundTo: Double) -> Int {
    return Int(roundTo) * Int(round(x / roundTo))
}

func addValues(_ maxValue: Double, _ view: UIView) {
    
    let labelCount: Int =  UIDevice.current.userInterfaceIdiom == .pad ? 8 : 4
    let rate: Int =  roundToNumber(maxValue / Double(labelCount + 1), roundTo: 5)
    let offSet = (view.bounds.height - 300) / CGFloat(labelCount + 1)
    
    for i in 1...labelCount {
        
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.text = String(rate * i) + " -"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        label.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -195 - (offSet * CGFloat(i))).isActive = true
    }
     
}


func drawAxis(vc: ViewController) {
    let xValue: CGFloat = 50.0
    let yValue: CGFloat = 150.0
    let yMax = vc.view.bounds.maxY - 216
    // draw axis
    let path = UIBezierPath()
 
    path.move(to: CGPoint(x: xValue, y: yValue))
    path.addLine(to: CGPoint(x: xValue, y: yMax))
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.strokeColor = UIColor.lightGray.cgColor
    shapeLayer.lineWidth = 2

    vc.view.layer.addSublayer(shapeLayer)
    
}
