//
//  VerticalStackedChart.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//
 
import UIKit

class VerticalStackedChart: ChartView {
    
    typealias ChartModel = (String, [(String, Double)])
    
    private var data: [ChartModel] = []
    private var sum: Double = 0
    
    func bind(dataSet: ChartDataSet) {
        
        let chartData = dataSet.data
        sum = chartData.compactMap({$0.seriesPoints.compactMap({ $0.value}).reduce(0, +)}).reduce(0, +)
        for j in 0...chartData[0].seriesPoints.count - 1 {
            let points: ChartModel =  (chartData[0].seriesPoints.map({ ($0.label) })[j], (chartData.map({ ( $0.seriesName, $0.seriesPoints.map({ ($0.value / sum) })[j]) })  ))
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
        
        let dataPairs = data.compactMap({ $0.1 })
        
        var pairSums : [Double] = []
        for pair in dataPairs {
            let sum =  pair.compactMap({ $0.1 }).reduce(0, +)
            pairSums.append(sum)
        }
        
        
        let maxRatio =  pairSums.max() ?? 1.0

        let maxValue: Double = maxRatio * sum
        addValuesYLabel(maxValue, vc.view)
        
        let maxHeight = ((rect.height - 70) / maxRatio)
        let division = (rect.width / CGFloat(multiData.count / data[0].1.count))
        let thickness = 0.4 * division

        var i: Int = 0
        var j: Int = 0

        borderColor.setStroke()
        context.setLineWidth(strokeWidth)
 
        let yMax = rect.height - 50
        
        data.forEach { key, mData in

            let labelValue: CGFloat = (CGFloat(i) * division) + 30.0
            
            var heightOffset: CGFloat = 0
            
            mData.forEach { _, value in

                let sectionHeight = value * maxHeight * 0.9
                
                let itemGap = CGFloat(i) * division
                
                let xValue: CGFloat = itemGap + 30
                // create path
                let path: UIBezierPath
                let shapeLayer = CAShapeLayer()

                if j == mData.count - 1 {
                    let shapeBounds = CGRect(x: xValue - thickness / 2, y: rect.height - 50 - sectionHeight - heightOffset, width: thickness, height: sectionHeight)
                    path = UIBezierPath(roundedRect: shapeBounds,
                                            byRoundingCorners: [.topLeft, .topRight],
                                        cornerRadii: CGSize(width: thickness / .pi, height: 0))
                } else {
                    
                    path = UIBezierPath()
                    path.move(to: CGPoint(x: xValue, y: rect.height - 50 - sectionHeight - heightOffset))
                    path.addLine(to: CGPoint(x: xValue, y: rect.height - 50 - heightOffset))
                    shapeLayer.lineWidth = thickness
                }
                 
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = colors[j].cgColor
                shapeLayer.fillColor = colors[j].cgColor

                shapeLayer.shadowColor = UIColor.black.cgColor
                shapeLayer.shadowOpacity = 1
                shapeLayer.shadowOffset = CGSize(width: 2.0, height: -2.0)
                shapeLayer.shadowRadius = 4

                layer.addSublayer(shapeLayer)
                
                heightOffset += sectionHeight
                j += 1

            }
                j = 0
            
            let labelPos = CGPoint(x: labelValue, y: yMax - 20)
            addLabel(labelPos, key)

            i = i >= colors.count ? 0 : i + 1
        }
        
        drawYAxis(vc: vc)
        
        // draw X Axis
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: rect.height - 50))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 50))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1

        layer.addSublayer(shapeLayer)
        //
    }
    
    
    func addLabel(_ leftPoint: CGPoint, _ title: String) {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        label.centerXAnchor.constraint(equalTo: leadingAnchor, constant: leftPoint.x).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: leftPoint.y + 30).isActive = true
    }
     
}


