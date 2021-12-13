//
//  HorizontalStackedChart.swift
//  PieChart
//
//  Created by Engin KUK on 12/1/21.
//

import UIKit

class HorizontalStackedChart: ChartViewArea {
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
        let dataPairs = data.compactMap({ $0.1 })

        var pairSums: [Double] = []
        for pair in dataPairs {
            let sum = pair.compactMap({ $0.1 }).reduce(0, +)
            pairSums.append(sum)
        }
        let maxRatio = pairSums.max() ?? 1.0
        let maxWidth = ((rect.width - 100) / maxRatio)

//        let maxValue = maxRatio * sum
//        masterView.addValuesXAxis(maxValue)

        var i: Int = 0
        var j: Int = 0

        data.forEach { key, mData in

            var widthOffset: CGFloat = 0
            let distanceAmongBars = (thickness + gap)
            let yValue: CGFloat = (CGFloat(i) * distanceAmongBars) + (gap + 0.5 * thickness)
            let bgViewWidth = maxRatio * maxWidth * 0.95

            // charts bg view
            let bgView = UIView()
            bgView.backgroundColor = .lightGray.withAlphaComponent(0.2)
            bgView.layer.cornerRadius = thickness / .pi
            bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            bgView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(bgView)
             
            NSLayoutConstraint.activate([
                bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
                bgView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                bgView.heightAnchor.constraint(equalToConstant: thickness),
                bgView.widthAnchor.constraint(equalToConstant: bgViewWidth),
            ])
             
            mData.forEach { groupName, value, index  in

                let sectionWidth = value * maxWidth * 0.95
 
                // create bar views
                let barView = BarView()
                barView.backgroundColor = colors[j]
                barView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(barView)
 
                let barLeadingAnchor =  barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75)
                
                NSLayoutConstraint.activate([
                    barLeadingAnchor,
                    barView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                    barView.heightAnchor.constraint(equalToConstant: thickness),
                    barView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
                ])
                  
                if j == mData.count - 1 {
                    barView.layer.cornerRadius = thickness / .pi
                    barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                }
                
                  // show zero height
                  layoutIfNeeded()
                
                  // animate to section height
                  barLeadingAnchor.constant = 75 + widthOffset
                  barView.widthAnchor.constraint(equalToConstant: sectionWidth).isActive = true
                  UIView.animate(withDuration: 0.5, delay: 0.1) {
                      self.layoutIfNeeded()
                  }
                 
                barView.color = colors[j]
                let labelName = key + " / " + groupName
                barView.seriesPoint = AxisData(index: 0, label: labelName, value: value * sum)

                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(sender:)))
                barView.addGestureRecognizer(tapGesture)
                
                widthOffset += sectionWidth
                j += 1
            }
            j = 0

            // add labels
            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = key
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 2
            addSubview(label)

            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(lessThanOrEqualToConstant: gap*2),
                label.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 71),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
                label.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
            ])

            i = i >= colors.count ? 0 : i + 1
        }
    }

}
