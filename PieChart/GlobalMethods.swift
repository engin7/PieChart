//
//  GlobalMethods.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//

import UIKit


// Global Methods

func roundToNumber(_ x : Double, roundTo: Double) -> Int {
return Int(roundTo) * Int(round(x / roundTo))
}

func addValuesYLabel(_ maxValue: Double, _ view: UIView) {

let labelCount: Int =  UIDevice.current.userInterfaceIdiom == .pad ? 8 : 4
let rate: Int =  roundToNumber(maxValue / Double(labelCount), roundTo: 5)
let offSet = (view.bounds.maxY - 247 - 150 - 20) / CGFloat(labelCount)

for i in 0...labelCount-1 {
    
    let label = UILabel()
    label.font = label.font.withSize(12)
    label.text = String(rate * (i+1)) + " -"
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)

    label.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
    label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -242 - (offSet * CGFloat(i+1)) ).isActive = true
}
 
}

func addValuesXLabel(_ maxValue: Double, _ view: UIView) {

let labelCount: Int =  UIDevice.current.userInterfaceIdiom == .pad ? 8 : 4
let rate: Int =  roundToNumber(maxValue / Double(labelCount), roundTo: 5)
let offSet = (view.bounds.width - 135) / CGFloat(labelCount)

for i in 1...labelCount {
    
    let label = UILabel()
    label.font = label.font.withSize(12)
    label.text = String(rate * i)
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)

    label.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 85 + (offSet * CGFloat(i))).isActive = true
    label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
}
 
}

func drawYAxis(vc: UIViewController) {
let xValue: CGFloat = 50.0
let yValue: CGFloat = 150.0
let yMax = vc.view.bounds.maxY - 247
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

func drawXAxis(vc: UIViewController) {
let xValue: CGFloat = 91.0
let yValue: CGFloat = vc.view.bounds.maxY - 150.0
let xMax = vc.view.bounds.maxX - 16
// draw axis
let path = UIBezierPath()

path.move(to: CGPoint(x: xValue, y: yValue))
path.addLine(to: CGPoint(x: xMax, y: yValue))

// seperators

let labelCount: Int =  UIDevice.current.userInterfaceIdiom == .pad ? 8 : 4
let diff = (xMax - xValue - 30) / CGFloat(labelCount)

for i in 1...labelCount {
    
    path.move(to: CGPoint(x: xValue + CGFloat(i) * diff - 5, y: yValue))
    path.addLine(to: CGPoint(x: xValue + CGFloat(i) * diff - 5, y: yValue+5))

}
 

let shapeLayer = CAShapeLayer()
shapeLayer.path = path.cgPath
shapeLayer.strokeColor = UIColor.lightGray.cgColor
shapeLayer.lineWidth = 2

vc.view.layer.addSublayer(shapeLayer)

}
