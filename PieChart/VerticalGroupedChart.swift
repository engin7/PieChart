//
//  VerticalGroupedChart.swift
//  PieChart
//
//  Created by Engin KUK on 29.11.2021.
//

import UIKit

class VerticalGroupedChart: UIView {
    
    typealias ChartModel = (String, [(String, Double)])
    
    private var data: [ChartModel] = []
    private var sum: Double = 0
    
    func set(dataSet: [SeriesDataSet]) {
        
     
        sum = dataSet.compactMap({$0.seriesPoints.compactMap({ $0.value}).reduce(0, +)}).reduce(0, +)
         
  
         
            for j in 0...dataSet[0].seriesPoints.count - 1 {
            let points: ChartModel =  (dataSet[0].seriesPoints.map({ ($0.label) })[j], (dataSet.map({ ( $0.seriesName, $0.seriesPoints.map({ ($0.value / sum) })[j]) })  ))
                print(points)
            data.append(points)
            }
         
   
        
//        seriesPoints.sorted(by: { $0.index < $1.index })
//        let sum = series.compactMap { $0.value }.reduce(0, +)
//        self.data = sum == 0 ? series.map { ($0.label, $0.multiData.map({ ($0.title, $0.value) })) } : series.map { ($0.label, $0.multiData.map({ ($0.title, $0.value / sum) })) }
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

        let multiData = data.flatMap({ $0.1 })
        let maxRatio = multiData.compactMap { $0.1 }.max() ?? 1.0

        let maxValue: Double = maxRatio * sum
        addValues(maxValue)
        
        let maxHeight = (rect.height / maxRatio) - 350
        let division = (rect.width / CGFloat(multiData.count / data[0].1.count))
        let thickness = 0.2 * division

        var i: Int = 0
        var j: Int = 0

        borderColor.setStroke()
        context.setLineWidth(strokeWidth)

        // draw axis
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 40.0, y: rect.height - 50))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 50))
        path.move(to: CGPoint(x: 40.0, y: 0))
        path.addLine(to: CGPoint(x: 40.0, y: rect.height - 50))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1

        layer.addSublayer(shapeLayer)

        let yMax = rect.height - 50
        
        data.forEach { key, mData in

            let labelValue: CGFloat = (CGFloat(i) * division * 0.9) + 70.0

            mData.forEach { _, value in

                let sectionHeight = value * maxHeight
                let groupGap = CGFloat(j) * division / CGFloat(mData.count) * 0.7
                let itemGap = CGFloat(i) * division * 0.9
                let xValue: CGFloat = itemGap + groupGap + 60
                // create path
                let path = UIBezierPath()
                path.move(to: CGPoint(x: xValue, y: yMax))
                path.addLine(to: CGPoint(x: xValue, y: yMax - sectionHeight))

                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = colors[j].cgColor
                shapeLayer.fillColor = colors[j].cgColor
                shapeLayer.lineWidth = thickness

                shapeLayer.shadowColor = UIColor.black.cgColor
                shapeLayer.shadowOpacity = 1
                shapeLayer.shadowOffset = CGSize(width: 2.0, height: -2.0)
                shapeLayer.shadowRadius = 4

                layer.addSublayer(shapeLayer)
                
                j += 1

            }
                j = 0
            
            let labelPos = CGPoint(x: labelValue, y: yMax - 20)
            addLabel(labelPos, key)

            i = i >= colors.count ? 0 : i + 1
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
        
        
        func roundToNumber(_ x : Double, roundTo: Double) -> Int {
            return Int(roundTo) * Int(round(x / roundTo))
        }
        
        func addValues(_ maxValue: Double) {
            
            let labelCount: Int =  UIDevice.current.userInterfaceIdiom == .pad ? 8 : 3
            let rate: Int =  roundToNumber(maxValue / Double(labelCount + 1), roundTo: 5)
            let startPoint = CGPoint(x:35.0, y: rect.height - 50 )
            let offSet = rect.height / CGFloat(labelCount + 1)
            
            for i in 1...labelCount {
                
                let label = UILabel()
                label.font = label.font.withSize(12)
                label.text = String(rate * i) + " -"
                label.translatesAutoresizingMaskIntoConstraints = false
                addSubview(label)

                label.trailingAnchor.constraint(equalTo: leadingAnchor, constant: startPoint.x).isActive = true
                label.topAnchor.constraint(equalTo: topAnchor, constant: startPoint.y - (offSet * CGFloat(i))).isActive = true
            }
            
           
            
        }
        
    }
}
