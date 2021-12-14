//
//  HorizontalGroupedChart.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//

import UIKit

class HorizontalGroupedChart: ChartViewArea {
    typealias ChartModel = (String, [(String, Double, Int)])

    private var data: [ChartModel] = []

    func bind(dataSet: ChartDataSet) {
        let chartData = dataSet.data
        var sortedData: [SeriesDataSet] = []
        
        chartData.forEach { seriesData in
            let sortedPoints = seriesData.seriesPoints.sorted(by: { $0.label > $1.label })
            
            let sortedSet = SeriesDataSet(seriesName: seriesData.seriesName, seriesPoints: sortedPoints)
            sortedData.append(sortedSet)
        }
        
        
        sum = sortedData.compactMap({ $0.seriesPoints.compactMap({ $0.value }).reduce(0, +) }).reduce(0, +)

        for j in 0 ... sortedData[0].seriesPoints.count - 1 {
            let points: ChartModel = (sortedData[0].seriesPoints.map({ ($0.label) })[j], sortedData.map({ ($0.seriesName, $0.seriesPoints.map({ ($0.value / sum) })[j], $0.seriesPoints.map({ ($0.index) })[j]) }))
            print(points)
            data.append(points)
        }
    }

    // MARK: - Aesthetics

    override func draw(_ rect: CGRect) {

        let multiData = data.flatMap({ $0.1 })
        let maxRatio = multiData.compactMap { $0.1 }.max() ?? 1.0
        let maxWidth = ((rect.width - 100) / maxRatio)

        let maxValue = maxRatio * sum
        vc.addValuesXAxis(maxValue)

        var i: Int = 0
        var j: Int = 0

        borderColor.setStroke()

        data.forEach { key, mData in

            let barAndGap = (thickness + gap)
            let distanceAmongGroups: CGFloat = (CGFloat(i) * (barAndGap + 0.5 * thickness) * CGFloat(mData.count))

            mData.forEach { groupName, value, index in

                let distanceAmongBars: CGFloat = (CGFloat(j) * barAndGap) + (barAndGap + 0.5 * thickness)
                let yValue: CGFloat = distanceAmongGroups + distanceAmongBars
                let sectionWidth = value * maxWidth * 0.95

                // create bar views
                let barView = BarView()
                barView.backgroundColor = colors[j]
                barView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(barView)

                NSLayoutConstraint.activate([
                    barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
                    barView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                    barView.widthAnchor.constraint(equalToConstant: sectionWidth),
                    barView.heightAnchor.constraint(equalToConstant: thickness),
                ])

                barView.layer.cornerRadius = thickness / .pi
                barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]

                barView.color = colors[j]
                barView.seriesPoint = AxisData(index: i, label: key, value: value)
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

            let labelY = distanceAmongGroups + (barAndGap + 0.5 * thickness) + CGFloat(mData.count - 1) * barAndGap * 0.5

            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
                label.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -labelY),
            ])
 
            if i != 0 {
                let notchView = UIView()
                notchView.backgroundColor = .lightGray
                notchView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(notchView)

                NSLayoutConstraint.activate([
                    notchView.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: ( 1.5*gap +  2.25*thickness)),
                    notchView.leadingAnchor.constraint(equalTo: vc.verticalLineView.leadingAnchor, constant: 2),
                    notchView.heightAnchor.constraint(equalToConstant: 2),
                    notchView.widthAnchor.constraint(equalToConstant: 12),
                ])
            }
            
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
