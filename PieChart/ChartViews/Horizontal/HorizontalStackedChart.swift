//
//  HorizontalStackedChart.swift
//  PieChart
//
//  Created by Engin KUK on 12/1/21.
//

import UIKit

class HorizontalStackedChart: ChartViewArea {
    typealias ChartModel = (String, [(String, Double)])

    private var data: [ChartModel] = []

    func bind(dataSet: ChartDataSet) {
        let chartData = dataSet.data
        sum = chartData.compactMap({ $0.seriesPoints.compactMap({ $0.value }).reduce(0, +) }).reduce(0, +)

        for j in 0 ... chartData[0].seriesPoints.count - 1 {
            let points: ChartModel = (chartData[0].seriesPoints.map({ ($0.label) })[j], chartData.map({ ($0.seriesName, $0.seriesPoints.map({ ($0.value / sum) })[j]) }))
            print(points)
            data.append(points)
        }
    }

    // MARK: - Aesthetics

    override func draw(_ rect: CGRect) {
        let dataPairs = data.compactMap({ $0.1 })

        var pairSums: [Double] = []
        for pair in dataPairs {
            let sum = pair.compactMap({ $0.1 }).reduce(0, +)
            pairSums.append(sum)
        }
        let maxRatio = pairSums.max() ?? 1.0
        let maxWidth = ((rect.width - 100) / maxRatio)

        let maxValue = maxRatio * sum
        vc.addValuesXAxis(maxValue)

        var i: Int = 0
        var j: Int = 0

        data.forEach { key, mData in

            var widthOffset: CGFloat = 0
            let distanceAmongBars = (thickness + gap)
            let yValue: CGFloat = (CGFloat(i) * distanceAmongBars) + (gap + 0.5 * thickness)
            
            mData.forEach { groupName, value in

                let sectionWidth = value * maxWidth * 0.95
                let bgViewWidth = maxRatio * maxWidth * 0.95
                
                // charts bg view
                let bgView = UIView()
                bgView.backgroundColor = .lightGray.withAlphaComponent(0.2)
                bgView.layer.cornerRadius = thickness / .pi
                bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                bgView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(bgView)
                
                
                // create bar views
                let barView = BarView()
                barView.backgroundColor = colors[j]
                barView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(barView)

                if j == mData.count - 1 {
                    barView.layer.cornerRadius = thickness / .pi
                    barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                }
 
                NSLayoutConstraint.activate([
                    bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75 + widthOffset),
                    bgView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                    bgView.heightAnchor.constraint(equalToConstant: thickness),
                    bgView.widthAnchor.constraint(equalToConstant: bgViewWidth),
 
                    barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
                    barView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                    barView.heightAnchor.constraint(equalToConstant: thickness),
                    barView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
                ])
 
                   // show zero height
                   layoutIfNeeded()
                 
                   // animate to section height
                   barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75 + widthOffset).isActive = true
                   barView.widthAnchor.constraint(equalToConstant: sectionWidth).isActive = true
                   UIView.animate(withDuration: 0.5, delay: 0.1) {
                       self.layoutIfNeeded()
                   }
                 
                barView.color = colors[j]
                barView.seriesPoint = AxisData(index: i, label: key, value: value)
                barView.point = CGPoint(x: barView.bounds.midX, y: barView.bounds.minY)
                
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(sender:)))
                barView.addGestureRecognizer(tapGesture)
                
                j += 1
                widthOffset += sectionWidth
            }
            j = 0

            // add labels
            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = key
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)

            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
                label.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
            ])

            i = i >= colors.count ? 0 : i + 1
        }
    }

}
