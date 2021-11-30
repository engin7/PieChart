//
//  VerticalChart.swift
//  PieChart
//
//  Created by Engin KUK on 11/28/21.
//
 
import UIKit


class VerticalChart: UIView {

private var data: [(String, CGFloat)] = []
private var sum: Double = 0
    
func set(dataSet: [SeriesDataSet]) {
    guard let seriesData = dataSet.first else { return }
    let series = seriesData.seriesPoints.sorted(by: { $0.index <  $1.index })
    sum = series.compactMap{ $0.value }.reduce(0, +)
    self.data = sum == 0 ? series.map{ ($0.label, CGFloat($0.value)) } : series.map{ ($0.label, CGFloat($0.value / sum)) }
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
        let maxHeight = (rect.height / maxRatio) - 250
        
        let maxValue: Double = maxRatio * sum
        addValues(maxValue, self)
        
        let division = (rect.width / CGFloat(data.count))
        let thickness = 0.4 * division
        
        var i: Int = 0

        borderColor.setStroke()
        context.setLineWidth(strokeWidth)
         
        data.forEach { (key, value) in
            
            let yMax = rect.height - 50
            let sectionHeight = value * maxHeight
            let xValue: CGFloat = (CGFloat(i) * division * 0.9) + 70.0

            // create path
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xValue, y: yMax))
            path.addLine(to: CGPoint(x: xValue, y: yMax - sectionHeight))
  
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = colors[i].cgColor
            shapeLayer.fillColor = colors[i].cgColor
            shapeLayer.lineWidth = thickness
            
            shapeLayer.shadowColor = UIColor.black.cgColor
            shapeLayer.shadowOpacity = 1
            shapeLayer.shadowOffset = CGSize(width:1.0, height:-1.0)
            shapeLayer.shadowRadius = 4
    
            
            layer.addSublayer(shapeLayer)
            
            let labelPos = CGPoint(x: xValue, y: yMax - 20)
            addLabel(labelPos, key)
             
            i = i >= colors.count ? 0 : i + 1
        }
    
        // draw axis
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 40.0, y: rect.height - 50))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 50))
        path.move(to: CGPoint(x: 40.0, y: 0))
        path.addLine(to: CGPoint(x: 40.0, y: rect.height - 50))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor =  UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        
        layer.addSublayer(shapeLayer)
    }
    
    func addLabel(_ leftPoint: CGPoint, _ title: String) {
            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = title
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
        
            label.centerXAnchor.constraint(equalTo: leadingAnchor, constant: leftPoint.x ).isActive = true
            label.topAnchor.constraint(equalTo: topAnchor, constant: leftPoint.y + 30).isActive = true
    }

    
}
