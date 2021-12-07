//
//  HorizontalChart.swift
//  PieChart
//
//  Created by Engin KUK on 26.11.2021.
//

import UIKit

class HorizontalChart: ChartViewArea {
    private var data: [(String, CGFloat)] = []
   
    func bind(dataSet: ChartDataSet) {
        guard let seriesData = dataSet.data.first else { return }
        let series = seriesData.seriesPoints.sorted(by: { $0.index < $1.index })
        sum = series.compactMap { $0.value }.reduce(0, +)
        data = sum == 0 ? series.map { ($0.label, CGFloat($0.value)) } : series.map { ($0.label, CGFloat($0.value / sum)) }
    }
    
    // MARK: - Aesthetics

    override func draw(_ rect: CGRect) {

        let maxRatio = data.compactMap { $0.1 }.max() ?? 1.0
        let maxWidth = ((rect.width - 125) / maxRatio)
        let maxValue = maxRatio * sum

        vc.addValuesXAxis(maxValue)

        var i: Int = 0


        data.forEach { key, value in

            let sectionWidth = value * maxWidth
            let distanceAmongBars = (thickness + gap)
            let yValue: CGFloat = (CGFloat(i) * distanceAmongBars) + (gap + 0.5 * thickness)

            // create bar views
            let barView = BarView()
            barView.backgroundColor = colors[i]
            addSubview(barView)

            barView.layer.cornerRadius = thickness / .pi
            barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
 
            barView.color = colors[i]
            barView.seriesPoint = AxisData(index: i, label: key, value: value)
            barView.point = CGPoint(x: barView.bounds.maxX, y: barView.bounds.midY)
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(sender:)))
            barView.addGestureRecognizer(tapGesture)
            
            NSLayoutConstraint.activate([
                barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
                barView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                barView.heightAnchor.constraint(equalToConstant: thickness),
                barView.widthAnchor.constraint(equalToConstant: sectionWidth),
            ])

            // add labels
            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = key
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)

            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: barView.leadingAnchor, constant: -5),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
                label.centerYAnchor.constraint(equalTo: barView.centerYAnchor),
            ])

            i = i >= colors.count ? 0 : i + 1
        }
    }
    
}
