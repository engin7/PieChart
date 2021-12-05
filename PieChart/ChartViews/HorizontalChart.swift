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
    private let thickness : CGFloat
    private let colors: [UIColor]
    private let strokeWidth: CGFloat
    private let borderColor: UIColor
    private let vc: ContainerViewController
    
    func bind(dataSet: ChartDataSet) {
        guard let seriesData = dataSet.data.first else { return }
        let series = seriesData.seriesPoints.sorted(by: { $0.index < $1.index })
        sum = series.compactMap { $0.value }.reduce(0, +)
        data = sum == 0 ? series.map { ($0.label, CGFloat($0.value)) } : series.map { ($0.label, CGFloat($0.value / sum)) }
    }

    // MARK: - Initializers

    init(_ vc: ContainerViewController, frame: CGRect, colors: [UIColor]? = nil, strokeWidth: CGFloat = 0, borderColor: UIColor = .black, thickness: CGFloat = 20) {
        self.thickness = thickness
        self.colors = colors ?? [UIColor.gray]
        self.strokeWidth = strokeWidth
        self.borderColor = borderColor
        self.vc = vc
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Aesthetics
 
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let maxRatio = data.compactMap { $0.1 }.max() ?? 1.0
        // 7
        let maxWidth = ((rect.width - 75) / maxRatio)

        let maxValue = maxRatio * sum

        vc.addValuesXLabel(maxValue)
        
        var i: Int = 0

        borderColor.setStroke()
        context.setLineWidth(strokeWidth)

        data.forEach { key, value in

            let sectionWidth = value * maxWidth
            let yValue: CGFloat = (CGFloat(i) * thickness * 2.5) + 30

            // create bar views
            let barView = UIView()
            barView.backgroundColor = colors[i]
            barView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(barView)
            
            NSLayoutConstraint.activate([
                barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
                barView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                barView.heightAnchor.constraint(equalToConstant: thickness),
                barView.widthAnchor.constraint(equalToConstant: sectionWidth)
            ])
            
            barView.layer.cornerRadius = thickness / .pi
            barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            
            barView.layer.shadowColor = UIColor.black.cgColor
            barView.layer.shadowOpacity = 1
            barView.layer.shadowOffset = CGSize(width: 1.0, height: -2.0)
            barView.layer.shadowRadius = 2
             
            let labelPos = CGPoint(x: 60, y: rect.maxY - yValue)
            addLabel(labelPos, key)

            i = i >= colors.count ? 0 : i + 1
        }

    }

    func addLabel(_ leftPoint: CGPoint, _ title: String) {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        label.trailingAnchor.constraint(equalTo: leadingAnchor, constant: leftPoint.x).isActive = true
        label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8).isActive = true
        label.centerYAnchor.constraint(equalTo: topAnchor, constant: leftPoint.y).isActive = true
    }
}
