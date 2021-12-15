//
//  VerticalGroupedChart.swift
//  PieChart
//
//  Created by Engin KUK on 29.11.2021.
//

import UIKit

class VerticalGroupedChart: ChartViewArea {
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

        let maxValue: Double = maxRatio * sum
        vc.addValuesYAxis(maxValue)

        let maxHeight = ((rect.height - 50) / maxRatio)

        var i: Int = 0
        var j: Int = 0

        borderColor.setStroke()

        data.forEach { key, mData in

            let barAndGap = (thickness + gap)
            let groupDistanceMultiplier = (barAndGap + 0.5 * thickness) * CGFloat(mData.count)
            let distanceAmongGroups: CGFloat = (CGFloat(i) * groupDistanceMultiplier)

            mData.forEach { groupName, value, index in

                let distanceAmongBars: CGFloat = (CGFloat(j) * barAndGap) + (barAndGap + 0.5 * thickness)
                let xValue: CGFloat = distanceAmongGroups + distanceAmongBars
                let sectionHeight = value * maxHeight * 0.95
                let bgViewHeight = maxRatio * maxHeight * 0.95

                
                // charts bg view
                let bgView = UIView()
                bgView.backgroundColor = .lightGray.withAlphaComponent(0.2)
                bgView.layer.cornerRadius = thickness / .pi
                bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                bgView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(bgView)
                
                
                // create bar views
                let barView = BarView()
                barView.backgroundColor = colors[i]
                barView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(barView)

                NSLayoutConstraint.activate([
                    bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                    bgView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xValue),
                    bgView.heightAnchor.constraint(equalToConstant: bgViewHeight),
                    bgView.widthAnchor.constraint(equalToConstant: thickness),
                    
                    barView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                    barView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xValue),
                    barView.widthAnchor.constraint(equalToConstant: thickness),
                    barView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
                ])

                barView.layer.cornerRadius = thickness / .pi
                barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

                // show zero height
                layoutIfNeeded()
              
                // animate to section height
                barView.heightAnchor.constraint(equalToConstant: sectionHeight).isActive = true
                UIView.animate(withDuration: 0.5, delay: 0.1) {
                    self.layoutIfNeeded()
                }
            
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

            if i != data.count-1 {
                let notchView = UIView()
                notchView.backgroundColor = .lightGray
                notchView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(notchView)

                NSLayoutConstraint.activate([
                    notchView.centerXAnchor.constraint(equalTo: label.centerXAnchor, constant: groupDistanceMultiplier * 0.5),
                    notchView.bottomAnchor.constraint(equalTo: vc.horizontalLineView.bottomAnchor, constant: -2),
                    notchView.heightAnchor.constraint(equalToConstant: 12),
                    notchView.widthAnchor.constraint(equalToConstant: 2),
                ])
            }
          
            
            i = i >= colors.count ? 0 : i + 1
        }
    }
 
}
