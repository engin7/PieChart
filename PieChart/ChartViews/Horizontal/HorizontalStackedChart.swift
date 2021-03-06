//
//  HorizontalStackedChart.swift
//  PieChart
//
//  Created by Engin KUK on 12/1/21.
//

import UIKit

class HorizontalStackedChart: ChartViewArea {
  
    private var sortedData: [SeriesDataSet] = []

    func bind(dataSet: ChartDataSet) {
        let chartData = dataSet.data
        sum = chartData.compactMap({ $0.seriesPoints.compactMap({ $0.value }).reduce(0, +) }).reduce(0, +)

        chartData.forEach { seriesData in
            let sortedPoints = seriesData.seriesPoints.sorted(by: { $0.label > $1.label })
            let sortedSet = SeriesDataSet(seriesName: seriesData.seriesName, seriesPoints: sortedPoints)
            sortedData.append(sortedSet)
        }

    }

    // MARK: - Aesthetics

    override func draw(_ rect: CGRect) {
        
        var pairs: [[Double]] = []
        for j in 0 ... sortedData[0].seriesPoints.count - 1 {
            let points: [Double] = (sortedData.map({ ($0.seriesPoints.map({ ($0.value) })[j]) }))
             pairs.append(points)
        }
        
        let pairSums = pairs.compactMap({ $0.reduce(0, +)})
        let maxPairs = (pairSums.max() ?? sum/Double(pairs.count))
        let maxWidth = rect.width - 100
  
        // we need to get reference for last top points inside each loop
        var widthOffset: [CGFloat] = Array(repeating: 0, count: pairs.count)
        
        sortedData.enumerated().forEach { i, mData in
  
            mData.seriesPoints.enumerated().forEach { j, sp in

                let distanceAmongBars = (thickness + gap)
                let yValue: CGFloat = (CGFloat(j) * distanceAmongBars) + (gap + 0.5 * thickness)
                let bgViewWidth =  maxWidth * 0.95
                let sectionWidth = sp.value/maxPairs * bgViewWidth

                if i == 0 {

                    let bgView = UIView()
                    bgView.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    bgView.layer.cornerRadius = thickness / .pi
                    bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                    bgView.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(bgView)
 
                    let label = UILabel()
                    label.font = label.font.withSize(12)
                    label.text = sp.label
                    label.textAlignment = .center
                    label.numberOfLines = 2
                    label.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(label)

                    NSLayoutConstraint.activate([
                        bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
                        bgView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                        bgView.heightAnchor.constraint(equalToConstant: thickness),
                        bgView.widthAnchor.constraint(equalToConstant: bgViewWidth),
                        label.heightAnchor.constraint(lessThanOrEqualToConstant: gap*2),
                        label.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 71),
                        label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
                        label.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                    ])
                }

                let color = colors[i]
                
                // create bar views
                let barView = BarView()
                barView.backgroundColor = color
                barView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(barView)

                let barLeadingAnchor =  barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75)

                NSLayoutConstraint.activate([
                    barLeadingAnchor,
                    barView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                    barView.heightAnchor.constraint(equalToConstant: thickness),
                    barView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
                ])

                if i == sortedData.count - 1 {
                    barView.layer.cornerRadius = thickness / .pi
                    barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                }

                // show zero height
                layoutIfNeeded()

                // animate to section width
                barLeadingAnchor.constant = 75 + widthOffset[j]
                barView.widthAnchor.constraint(equalToConstant: sectionWidth).isActive = true
                 
                UIView.animate(withDuration: 0.5, delay: 0.5) {
                    self.layoutIfNeeded()
                }
 
                barView.seriesPoint = AxisData(index: sp.index, label: sp.label, value: sp.value)
                barView.color = color

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
                barView.addGestureRecognizer(tapGesture)

                widthOffset[j] += sectionWidth
    
            }
        }
    }

}
