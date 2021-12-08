//
//  VerticalGroupedChart.swift
//  PieChart
//
//  Created by Engin KUK on 29.11.2021.
//

import UIKit

class VerticalGroupedChart: ChartViewArea {
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

        let multiData = data.flatMap({ $0.1 })
        let maxRatio = multiData.compactMap { $0.1 }.max() ?? 1.0

        let maxValue: Double = maxRatio * sum
        vc.addValuesYAxis(maxValue)

        let maxHeight = ((rect.height - 50) / maxRatio)

        var i: Int = 0
        var j: Int = 0

        borderColor.setStroke()

        data.forEach { key, mData in

            let barAndGap = (thickness + gap)
            let distanceAmongGroups: CGFloat = (CGFloat(i) * (barAndGap + 0.5 * thickness) * CGFloat(mData.count))

            mData.forEach { groupName, value in

                let distanceAmongBars: CGFloat = (CGFloat(j) * barAndGap) + (barAndGap + 0.5 * thickness)
                let xValue: CGFloat = distanceAmongGroups + distanceAmongBars
                let sectionHeight = value * maxHeight * 0.95

                // create bar views
                let barView = BarView()
                barView.backgroundColor = colors[i]
                barView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(barView)

                NSLayoutConstraint.activate([
                    barView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
                    barView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xValue),
                    barView.heightAnchor.constraint(equalToConstant: sectionHeight),
                    barView.widthAnchor.constraint(equalToConstant: thickness),
                ])

                barView.layer.cornerRadius = thickness / .pi
                barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

                barView.layer.shadowColor = UIColor.black.cgColor
                barView.layer.shadowOpacity = 1
                barView.layer.shadowOffset = CGSize(width: 1.0, height: -2.0)
                barView.layer.shadowRadius = 2

                barView.color = colors[j]
                barView.seriesPoint = AxisData(index: j, label: key, value: value*sum)
                barView.point = CGPoint(x: barView.bounds.midX, y: barView.bounds.minY)

                
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(sender:)))
                barView.addGestureRecognizer(tapGesture)
                
                j += 1
            }
            j = 0

   
            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = key
            label.textAlignment = .center
            label.numberOfLines = 1
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)

            let labelX = distanceAmongGroups + (barAndGap + 0.5 * thickness) + CGFloat(mData.count - 1) * barAndGap * 0.5
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
            label.centerXAnchor.constraint(equalTo: leadingAnchor, constant: labelX).isActive = true
            label.topAnchor.constraint(equalTo: bottomAnchor, constant: -45).isActive = true

            i = i >= colors.count ? 0 : i + 1
        }
    }

    func addLabel(_ leftPoint: CGPoint, _ title: String) {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        label.widthAnchor.constraint(lessThanOrEqualToConstant: 80).isActive = true
        label.centerXAnchor.constraint(equalTo: leadingAnchor, constant: leftPoint.x).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: leftPoint.y + 30).isActive = true
    }
}
