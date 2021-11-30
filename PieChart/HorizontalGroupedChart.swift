//
//  HorizontalGroupedChart.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//
 
import UIKit

class HorizontalGroupedChart: ChartView {
    
    typealias ChartModel = (String, [(String, Double)])
    
    private var data: [ChartModel] = []
    private var sum: Double = 0
    
    func bind(dataSet: ChartDataSet) {
        
        let chartData = dataSet.data
        sum = chartData.compactMap({$0.seriesPoints.compactMap({ $0.value}).reduce(0, +)}).reduce(0, +)
          
        for j in 0...chartData[0].seriesPoints.count - 1 {
            let points: ChartModel =  (chartData[0].seriesPoints.map({ ($0.label) })[j], (chartData.map({ ( $0.seriesName, $0.seriesPoints.map({ ($0.value / sum) })[j]) })  ))
                print(points)
            data.append(points)
            }
    }

    // MARK: - Initializers

    init(frame: CGRect, colors: [UIColor]? = nil, strokeWidth: CGFloat = 0, borderColor: UIColor = .black) {
        super.init(frame: frame)
        self.colors = colors ?? self.colors
        self.strokeWidth = strokeWidth
        self.borderColor = borderColor
        backgroundColor = .clear
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
        guard let vc = masterVC else { return }

        let multiData = data.flatMap({ $0.1 })
        let maxRatio = multiData.compactMap { $0.1 }.max() ?? 1.0
        let maxWidth = (rect.width / maxRatio) * 0.7

        let maxValue = maxRatio * sum
        addValuesXLabel(maxValue, vc.view)

        let division = (rect.height / CGFloat(multiData.count / data[0].1.count))
        let thickness = 0.2 * division

        var i: Int = 0
        var j: Int = 0
        
        borderColor.setStroke()
        context.setLineWidth(strokeWidth)
        
        data.forEach { key, mData in
            
            let labelValue: CGFloat = (CGFloat(i) * division * 0.9) + 30.0

            mData.forEach { _, value in
            
                
                let sectionWidth = value * maxWidth * 0.9
                let groupGap = CGFloat(j) * division / CGFloat(mData.count) * 0.7
                let itemGap = CGFloat(i) * division * 0.9
                let yValue: CGFloat = itemGap + groupGap  + 20

            // create path
            let shapeBounds = CGRect(x: 75, y: yValue - thickness / 2, width: sectionWidth, height: thickness)
            let path = UIBezierPath(roundedRect: shapeBounds,
                                    byRoundingCorners: [.bottomRight, .topRight],
                                    cornerRadii: CGSize(width: thickness / 2, height: thickness / 2))
 
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = colors[i].cgColor
            shapeLayer.fillColor = colors[i].cgColor

            shapeLayer.shadowColor = UIColor.black.cgColor
            shapeLayer.shadowOpacity = 1
            shapeLayer.shadowOffset = CGSize(width: 1.0, height: -2.0)
            shapeLayer.shadowRadius = 2

            layer.addSublayer(shapeLayer)
                
                j += 1
                
            }
                j = 0
            
            let labelPos = CGPoint(x: 0, y: labelValue)
            addLabel(labelPos, key)

            i = i >= colors.count ? 0 : i + 1
        }

        drawXAxis(vc: vc)

        // draw Y axis
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 75.0, y: 0))
        path.addLine(to: CGPoint(x: 75.0, y: rect.height))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1

        layer.addSublayer(shapeLayer)
    }
    
    
    func addLabel(_ leftPoint: CGPoint, _ title: String) {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPoint.x).isActive = true
        label.centerYAnchor.constraint(equalTo: topAnchor, constant: leftPoint.y).isActive = true
    }
     
}


