//
//  HorizontalChart.swift
//  PieChart
//
//  Created by Engin KUK on 26.11.2021.
//

import UIKit

class HorizontalChart: ChartView {
    private var data: [(String, CGFloat)] = []
    private var sum: Double = 0

    func bind(dataSet: ChartDataSet) {
        guard let seriesData = dataSet.data.first else { return }
        let series = seriesData.seriesPoints.sorted(by: { $0.index < $1.index })
        sum = series.compactMap { $0.value }.reduce(0, +)
        data = sum == 0 ? series.map { ($0.label, CGFloat($0.value)) } : series.map { ($0.label, CGFloat($0.value / sum)) }
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

        let maxRatio = data.compactMap { $0.1 }.max() ?? 1.0
        // 7
        let maxWidth = ((rect.width - 90) / maxRatio)

        let maxValue = maxRatio * sum
        addValuesXLabel(maxValue, vc.view)

        let division = (rect.height / CGFloat(data.count))
        let thickness = 0.4 * division

        var i: Int = 0

        borderColor.setStroke()
        context.setLineWidth(strokeWidth)

        data.forEach { key, value in

            let sectionWidth = value * maxWidth
            let yValue: CGFloat = (CGFloat(i) * division) + 30

            // create path
            let shapeBounds = CGRect(x: 75, y: yValue - thickness / 2, width: sectionWidth, height: thickness)
            let path = UIBezierPath(roundedRect: shapeBounds,
                                    byRoundingCorners: [.bottomRight, .topRight],
                                    cornerRadii: CGSize(width: thickness / .pi, height: 0))
 
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = colors[i].cgColor
            shapeLayer.fillColor = colors[i].cgColor
//            shapeLayer.lineWidth = thickness

            shapeLayer.shadowColor = UIColor.black.cgColor
            shapeLayer.shadowOpacity = 1
            shapeLayer.shadowOffset = CGSize(width: 1.0, height: -2.0)
            shapeLayer.shadowRadius = 2

            layer.addSublayer(shapeLayer)

            let labelPos = CGPoint(x: 60, y: yValue)
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

        label.trailingAnchor.constraint(equalTo: leadingAnchor, constant: leftPoint.x).isActive = true
        label.centerYAnchor.constraint(equalTo: topAnchor, constant: leftPoint.y).isActive = true
    }
}
