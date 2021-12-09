//
//  LineChart.swift
//  PieChart
//
//  Created by Engin KUK on 8.12.2021.
//

import Foundation

import UIKit

class LineChart: ChartViewArea {
    
    private var data: [(String, CGFloat)] = []
 
    func bind(dataSet: ChartDataSet) {
        guard let seriesData = dataSet.data.first else { return }
        let series = seriesData.seriesPoints.sorted(by: { $0.index < $1.index })
        sum = series.compactMap { $0.value }.reduce(0, +)
        data = sum == 0 ? series.map { ($0.label, CGFloat($0.value)) } : series.map { ($0.label, CGFloat($0.value / sum)) }
        plot(data)
    }


    // MARK: - Aesthetics

    let lineLayer = CAShapeLayer()
    let circlesLayer = CAShapeLayer()

    var chartTransform: CGAffineTransform?

    @IBInspectable var lineColor: UIColor = UIColor.green {
        didSet {
            lineLayer.strokeColor = lineColor.cgColor
        }
    }

    @IBInspectable var lineWidth: CGFloat = 2

    @IBInspectable var showPoints: Bool = true { // show the circles on each data point
        didSet {
            circlesLayer.isHidden = !showPoints
        }
    }

    @IBInspectable var circleColor: UIColor = UIColor.green {
        didSet {
            circlesLayer.fillColor = circleColor.cgColor
        }
    }

    @IBInspectable var circleSizeMultiplier: CGFloat = 3

    @IBInspectable var axisColor: UIColor = UIColor.white
    @IBInspectable var showInnerLines: Bool = true
    @IBInspectable var labelFontSize: CGFloat = 10

    var axisLineWidth: CGFloat = 1
    var deltaX: CGFloat = 0 // The change between each tick on the x axis
    var deltaY: CGFloat = 0 // and y axis
    var xMax: CGFloat = 100
    var yMax: CGFloat = 100
    var xMin: CGFloat = 0
    var yMin: CGFloat = 0

 
    func addLines() {
        layer.addSublayer(lineLayer)
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.lineWidth = lineWidth
        
        layer.addSublayer(circlesLayer)
        circlesLayer.fillColor = circleColor.cgColor

        layer.borderWidth = 1
        layer.borderColor = axisColor.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addLines()
        lineLayer.frame = bounds
        circlesLayer.frame = bounds

        if !data.isEmpty {
            setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
            plot(data)
        }

    }
    
    // to setup the transform
    func setAxisRange(forData data: [(String, CGFloat)]) {
        guard !data.isEmpty else { return }
    
        let xs = CGFloat(data.map() { $0.0 }.count) * thickness
        let ys = data.map() { $0.1*sum }
        
        xMax = ceil(xs )
        yMax = ceil(ys.max()! )
        xMin = 0
        yMin = 0
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
        
        addLabel()

    }
    
    func addLabel() {
        
        let strings = data.map() { $0.0 }
        
        for (index, str) in strings.enumerated() {
            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = str
            label.textAlignment = .center
            label.numberOfLines = 1
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)

            setNeedsDisplay()
            
            let distanceAmongBars = (thickness + gap)
            let xValue: CGFloat = (CGFloat(index) * distanceAmongBars) + (gap + 0.5 * thickness)
             
            let offsetPoint = CGPoint(x: xValue, y: -40.0)
            
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
            label.centerXAnchor.constraint(equalTo: leadingAnchor, constant: offsetPoint.x).isActive = true
            label.topAnchor.constraint(equalTo: bottomAnchor, constant: offsetPoint.y).isActive = true
        }
       
        
    }
    
    
    func setAxisRange(xMin: CGFloat, xMax: CGFloat, yMin: CGFloat, yMax: CGFloat) {
        self.xMin = xMin
        self.xMax = xMax
        self.yMin = yMin
        self.yMax = yMax
        
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
    }

    //  construct the affine transform we use for drawing the axes and all the points.
    func setTransform(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        
        let xOffset = 50.0
        let yScale = (bounds.height - 50)/(maxY - minY) * 0.95
        
        chartTransform = CGAffineTransform(a: 1.0, b: 0, c: 0, d: -yScale, tx: (gap + 0.5 * thickness)  , ty:   bounds.height - xOffset)
   
        setNeedsDisplay()

    }
    
    
    func plot(_ data: [(String, CGFloat)]) {
        lineLayer.path = nil
        circlesLayer.path = nil
      
        
        if self.chartTransform == nil {
            setAxisRange(forData: data)
        }
         
        let distanceAmongLabels = (thickness + gap)

        let pointsData: [CGPoint] = data.enumerated().map{
              CGPoint(x: distanceAmongLabels * CGFloat($0), y: $1.1*sum)
        }
        
        // setup our line path and our circle path
        
        let linePath = CGMutablePath()
        linePath.addLines(between: pointsData, transform: chartTransform!)
        
        lineLayer.path = linePath
         
        if showPoints {
            circlesLayer.path = circles(atPoints: pointsData, withTransform: chartTransform!)
        }
    }
    
    func circles(atPoints points: [CGPoint], withTransform t: CGAffineTransform) -> CGPath {
        
        let path = CGMutablePath()
        let radius = lineLayer.lineWidth * circleSizeMultiplier/2
        
        // trace a rect at each point, centered on that point, then we draw a circle in that rect.
        for i in points {
            let p = i.applying(t)
            let rect = CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)
            path.addEllipse(in: rect)
            
        }
        
        return path
    }
 

    override func draw(_ rect: CGRect) {
        vc.addValuesYAxis(yMax)
    }
    
 
}

// getting the rendered size of a string and avoid the typecasting as NSString all the time

extension String {
    func size(withSystemFontSize pointSize: CGFloat) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: pointSize)])
    }
}

extension CGPoint {
    func adding(x: CGFloat) -> CGPoint { return CGPoint(x: self.x + x, y: y) }
    func adding(y: CGFloat) -> CGPoint { return CGPoint(x: x, y: self.y + y) }
}

//affine transform works like this (arguments are a,b,c,d,tx,ty):
//a: scale x relative to old x | newX = a * oldX
//d: scale y relative to old y | newY = d * oldY
//tx: translate newX using the scale system of old x | newX = oldX * a + tX
//ty: same as tx
//b,c scale x & y relative to old y & x respectively — this causes rotation so we don’t care right now and thus they are both zero.
