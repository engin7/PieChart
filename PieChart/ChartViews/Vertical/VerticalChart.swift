//
//  VerticalChart.swift
//  PieChart
//
//  Created by Engin KUK on 11/28/21.
//

import UIKit

class VerticalChart: ChartViewArea {
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
        let maxHeight = ((rect.height - 75) / maxRatio)

        let maxValue: Double = maxRatio * sum
        vc.addValuesYAxis(maxValue)

        var i: Int = 0

        borderColor.setStroke()

        data.forEach { key, value in

            let sectionHeight = value * maxHeight
            let distanceAmongBars = (thickness + gap)
            let xValue: CGFloat = (CGFloat(i) * distanceAmongBars) + (gap + 0.5 * thickness)
            // create bar views
            let barView = BarView()
            barView.backgroundColor = colors[i]
            addSubview(barView)

            NSLayoutConstraint.activate([
                barView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
                barView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xValue),
                barView.heightAnchor.constraint(equalToConstant: sectionHeight),
                barView.widthAnchor.constraint(equalToConstant: thickness),
            ])

            barView.layer.cornerRadius = thickness / .pi
            barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
 
            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = key
            label.textAlignment = .center
            label.numberOfLines = 1
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)

            label.widthAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
            label.centerXAnchor.constraint(equalTo: barView.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 5).isActive = true

            layoutIfNeeded()
            let p = CGPoint(x: barView.frame.midX, y: barView.frame.minY)
            barView.point = superview?.convert(p, to: nil)
            barView.color = colors[i]
            barView.seriesPoint = AxisData(index: i, label: key, value: value*sum)
            
            print(p)
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(sender:)))
            barView.addGestureRecognizer(tapGesture)
 

            i = i >= colors.count ? 0 : i + 1
        }
    }
}

