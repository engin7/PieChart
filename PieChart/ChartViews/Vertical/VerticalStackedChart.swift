//
//  VerticalStackedChart.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//

import UIKit

class VerticalStackedChart: ChartViewArea {
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
        let maxHeight = rect.height - 50
         
        // we need to get reference for last top points inside each loop 
        var heightOffset: [CGFloat] = Array(repeating: 0, count: pairs.count)
        
        sortedData.enumerated().forEach { i, mData in
  
            mData.seriesPoints.enumerated().forEach { j, sp in

                let distanceAmongBars = (thickness + gap)
                let xValue: CGFloat = (CGFloat(j) * distanceAmongBars) + (gap + 0.5 * thickness)
                let bgViewHeight =  maxHeight * 0.95
                let sectionHeight = sp.value/maxPairs * bgViewHeight

                if i == 0 {
                    // charts bg view
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
                        bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                        bgView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xValue),
                        bgView.heightAnchor.constraint(equalToConstant: bgViewHeight),
                        bgView.widthAnchor.constraint(equalToConstant: thickness),
                        label.widthAnchor.constraint(lessThanOrEqualToConstant: 1.4 * gap),
                        label.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xValue),
                        label.topAnchor.constraint(equalTo: vc.horizontalLineView.bottomAnchor, constant: 4),
                    ])
                    
                }

                let color = colors[i]
                
                // create bar views
                let barView = BarView()
                barView.backgroundColor = color
                barView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(barView)

                NSLayoutConstraint.activate([
                    barView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                    barView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xValue),
                    barView.widthAnchor.constraint(equalToConstant: thickness),
                    barView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
                ])

                if i == sortedData.count - 1 {
                    barView.layer.cornerRadius = thickness / .pi
                    barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                }

                // show zero height
                layoutIfNeeded()

                // animate to section height
                barView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -heightOffset[j] - 32).isActive = true
                barView.heightAnchor.constraint(equalToConstant: sectionHeight).isActive = true
                UIView.animate(withDuration: 0.5, delay: 0.5) {
                    self.layoutIfNeeded()
                }
 
                barView.seriesPoint = AxisData(index: sp.index, label: sp.label, value: sp.value)
                barView.color = color

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
                barView.addGestureRecognizer(tapGesture)

                heightOffset[j] += sectionHeight
              
            }
        }
    }
}
