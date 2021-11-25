//
//  PieChartView.swift
//  PieChart
//
//  Created by Engin KUK on 25.11.2021.
//
 
import UIKit

class PieChartView: UIView {
    // MARK: - Data
    
    private var data: [(String, CGFloat)] = []
    
    func set(data: [String:Float]) {
        let sum = data.compactMap{ $0.value }.reduce(0, +)
        self.data = sum == 0 ? data.map{ ($0.0, CGFloat($0.1)) } : data.map{ ($0.0, CGFloat($0.1 / sum)) }.sorted(by: { $0.1 > $1.1 })
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
        
        let center = CGPoint(x: 0.5*rect.width, y: 0.5*rect.height)
        let radius = min(0.5*rect.width, 0.5*rect.height) - 0.5 * strokeWidth
        
        var accumulatedAngle: CGFloat = -0.5 * CGFloat.pi
        var i: Int = 0
        
        borderColor.setStroke()
        context.setLineWidth(strokeWidth)
        
        data.forEach { (key, value) in
            let angle = value * 2 * CGFloat.pi
            // create path
            let path = CGMutablePath()
            path.move(to: CGPoint())
            path.addLine(to: CGPoint(x: radius, y: 0))
            path.addRelativeArc(
                center: CGPoint(),
                radius: radius,
                startAngle: 0,
                delta: angle)
            path.closeSubpath()
            
            context.saveGState()
            
            context.translateBy(x: center.x, y: center.y)
            context.rotate(by: accumulatedAngle)
            // draw

            context.addPath(path)
            colors[i].setFill()
            context.fillPath()
            context.addPath(path)

            context.strokePath()
              
            let startAngle =  -accumulatedAngle
            let endAngle =  (startAngle - angle)
            
            let midPointAngle = ((startAngle + endAngle) / 2.0)
            let midPoint = CGPoint(x: center.x + 0.7 * radius * cos(midPointAngle), y: center.y - 0.7 * radius * sin(midPointAngle))
           
            addLabel(midPoint, key)
  
            context.restoreGState()
 
            accumulatedAngle += angle
            i = i >= colors.count ? 0 : i + 1
        }
    }
    
    
    func addLabel(_ midPoint: CGPoint, _ title: String) {
            let label = UILabel()
            label.text = title
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
        
            label.centerXAnchor.constraint(equalTo: leadingAnchor, constant: midPoint.x).isActive = true
            label.centerYAnchor.constraint(equalTo: topAnchor, constant: midPoint.y).isActive = true
    }
    
    
}
