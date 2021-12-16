//
//  HorizontalGroupedChart.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//

import UIKit

class HorizontalGroupedChart: ChartViewArea {

    
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
        
        let multiData = sortedData.flatMap({ $0.seriesPoints })
        let maxRatio = multiData.compactMap { $0.value }.max() ?? 1.0
        let maxWidth = (rect.width - 100) / maxRatio
        let maxValue: Double = maxRatio * sum
        vc.addValuesXAxis(maxValue)
 
        sortedData.enumerated().forEach { i, mData in
             
            let barAndGap = (thickness + gap)
            let groupDistanceMultiplier = (barAndGap + 0.5 * thickness) * CGFloat( mData.seriesPoints.count)
            let distanceAmongGroups: CGFloat = (CGFloat(i) * groupDistanceMultiplier)
            
            mData.seriesPoints.enumerated().forEach { j, sp in
        

                let distanceAmongBars: CGFloat = (CGFloat(j) * barAndGap) + (barAndGap + 0.5 * thickness)
                let yValue: CGFloat = distanceAmongGroups + distanceAmongBars
                let sectionWidth = sp.value * maxWidth * 0.95
                let bgViewWidth = maxRatio * maxWidth * 0.95

                
                // charts bg view
                let bgView = UIView()
                bgView.backgroundColor = .lightGray.withAlphaComponent(0.2)
                bgView.layer.cornerRadius = thickness / .pi
                bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                bgView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(bgView)
                
                let color = colors[j]
                // create bar views
                let barView = BarView()
                barView.backgroundColor = color
                barView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(barView)

                NSLayoutConstraint.activate([
                    bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
                    bgView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                    bgView.heightAnchor.constraint(equalToConstant: thickness),
                    bgView.widthAnchor.constraint(equalToConstant: bgViewWidth),
                    
                    barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
                    barView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                    barView.heightAnchor.constraint(equalToConstant: thickness),
                    barView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
                ])

                barView.layer.cornerRadius = thickness / .pi
                barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
  
                // show zero height
                layoutIfNeeded()
              
                // animate to section height
                barView.widthAnchor.constraint(equalToConstant: sectionWidth).isActive = true
                UIView.animate(withDuration: 0.5, delay: 0.5) {
                    self.layoutIfNeeded()
                }
            
                barView.color = color
                barView.seriesPoint = AxisData(index: sp.index, label: sp.label, value: sp.value)
                barView.point = CGPoint(x: barView.bounds.midX, y: barView.bounds.minY)

                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(sender:)))
                barView.addGestureRecognizer(tapGesture)
                
            }
             
            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = mData.seriesName
            label.textAlignment = .center
            label.numberOfLines = 1
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)

            let labelY = distanceAmongGroups + (barAndGap + 0.5 * thickness) + CGFloat(mData.seriesName.count - 1) * barAndGap * 0.5

            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(lessThanOrEqualToConstant: groupDistanceMultiplier * 0.8),
                label.trailingAnchor.constraint(equalTo: vc.verticalLineView.leadingAnchor, constant: -4),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
                label.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -labelY),
            ])
            
            if i != 0 {
                let notchView = UIView()
                notchView.backgroundColor = .lightGray
                notchView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(notchView)

                NSLayoutConstraint.activate([
                    notchView.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0.5 * groupDistanceMultiplier),
                    notchView.leadingAnchor.constraint(equalTo: vc.verticalLineView.leadingAnchor, constant: 2),
                    notchView.heightAnchor.constraint(equalToConstant: 2),
                    notchView.widthAnchor.constraint(equalToConstant: 12),
                ])
            }
            
        }
    }

}
