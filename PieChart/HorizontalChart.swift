//
//  HorizontalChart.swift
//  PieChart
//
//  Created by Engin KUK on 26.11.2021.
//

import UIKit


class HorizontalChart: UIView {

private var data: [(String, CGFloat)] = []
    
func set(data: SeriesDataSet) {
    let series = data.seriesPoints.sorted(by: { $0.index <  $1.index })
    let sum = series.compactMap{ $0.value as? CGFloat}.reduce(0, +)
    self.data = sum == 0 ? series.map{ ($0.label, CGFloat($0.value as! CGFloat)) } : series.map{ ($0.label, CGFloat($0.value as! CGFloat / sum)) }
}

// MARK: - Initializers

init(frame: CGRect, colors: [UIColor]? = nil, strokeWidth: CGFloat = 0, borderColor: UIColor = .black) {
    super.init(frame: frame)
    
    self.colors = colors ?? self.colors
    self.strokeWidth = strokeWidth
    self.borderColor = borderColor
    
    self.backgroundColor = .clear
     
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

    // MARK: - Aesthetics
    
    var colors: [UIColor] = [UIColor.gray]
    var strokeWidth: CGFloat = 0
    var borderColor = UIColor.black
 
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
         
        let maxRatio = data.compactMap { $0.1 }.max() ?? 1.0
        let maxWidth = (rect.width / maxRatio) - 250
        let division = (rect.height / CGFloat(data.count))
        let thickness = 0.5 * division
        
        var i: Int = 0

        borderColor.setStroke()
        context.setLineWidth(strokeWidth)
        
        // draw axis
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 75.0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.move(to: CGPoint(x: 75.0, y: 0))
        path.addLine(to: CGPoint(x: 75.0, y: rect.height))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor =  UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        
        layer.addSublayer(shapeLayer)
        
        data.forEach { (key, value) in
            
            let sectionWidth = value * maxWidth
            let yValue: CGFloat = (CGFloat(i) * division) + 30.0

            // create path
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 85.0, y: yValue))
            path.addLine(to: CGPoint(x: 85.0 + sectionWidth, y: yValue))
  
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = colors[i].cgColor
            shapeLayer.fillColor = colors[i].cgColor
            shapeLayer.lineWidth = thickness
            
            shapeLayer.shadowColor = UIColor.black.cgColor
            shapeLayer.shadowOpacity = 1
            shapeLayer.shadowOffset = CGSize(width:1.0, height:1.0)
            shapeLayer.shadowRadius = 4
    
            
            layer.addSublayer(shapeLayer)
            
            let labelPos = CGPoint(x: 0, y: yValue)
            addLabel(labelPos, key)
             
            i = i >= colors.count ? 0 : i + 1
        }
    
    }
    
    func addLabel(_ leftPoint: CGPoint, _ title: String) {
            let label = UILabel()
            label.text = title
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
        
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPoint.x + 5).isActive = true
            label.centerYAnchor.constraint(equalTo: topAnchor, constant: leftPoint.y).isActive = true
    }

}