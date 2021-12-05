//
//  HorizontalStackedChart.swift
//  PieChart
//
//  Created by Engin KUK on 12/1/21.
//

import UIKit

class HorizontalStackedChart: ChartView {
    
    typealias ChartModel = (String, [(String, Double)])
    
    private var data: [ChartModel] = []
    private var sum: Double = 0
    private let thickness : CGFloat
    private let gap: CGFloat
    private let colors: [UIColor]
    private let strokeWidth: CGFloat
    private let borderColor: UIColor
    private let vc: ContainerViewController
      
    func bind(dataSet: ChartDataSet) {
        
        let chartData = dataSet.data
        sum = chartData.compactMap({$0.seriesPoints.compactMap({ $0.value}).reduce(0, +)}).reduce(0, +)
          
        for j in 0...chartData[0].seriesPoints.count - 1 {
            let points: ChartModel =  (chartData[0].seriesPoints.map({ ($0.label) })[j], (chartData.map({ ( $0.seriesName, $0.seriesPoints.map({ ($0.value / sum) })[j]) })  ))
                print(points)
            data.append(points)
            }
    }

    // MARK: - Initializers

    init(_ vc: ContainerViewController, frame: CGRect, colors: [UIColor]? = nil, strokeWidth: CGFloat = 0, borderColor: UIColor = .black, thickness: CGFloat, gap: CGFloat) {
        self.thickness = thickness
        self.gap = gap
        self.colors = colors ?? [UIColor.gray]
        self.strokeWidth = strokeWidth
        self.borderColor = borderColor
        self.vc = vc
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Aesthetics
 
    override func draw(_ rect: CGRect) {

        let dataPairs = data.compactMap({ $0.1 })
        
        var pairSums : [Double] = []
        for pair in dataPairs {
            let sum =  pair.compactMap({ $0.1 }).reduce(0, +)
            pairSums.append(sum)
        }
        let maxRatio =  pairSums.max() ?? 1.0
        let maxWidth = ((rect.width - 125) / maxRatio)
 
        let maxValue = maxRatio * sum
        vc.addValuesXAxis(maxValue)
 
        var i: Int = 0
        var j: Int = 0
         
        data.forEach { key, mData in
            
            let yValue: CGFloat = (CGFloat(i) * thickness * 2.5) + 30

            var widthOffset: CGFloat = 0

            mData.forEach { _, value in
             
                let sectionWidth = value * maxWidth
                let distanceAmongBars = (thickness + gap)
                let yValue: CGFloat = (CGFloat(i) * distanceAmongBars) + (gap + 0.5*thickness)

                // create bar views
                let barView = UIView()
                barView.backgroundColor = colors[j]
                barView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(barView)
                 
                if j == mData.count - 1 {
                    barView.layer.cornerRadius = thickness / .pi
                    barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                }
              
                
                barView.layer.shadowColor = UIColor.black.cgColor
                barView.layer.shadowOpacity = 1
                barView.layer.shadowOffset = CGSize(width: 1.0, height: -2.0)
                barView.layer.shadowRadius = 2
                 
                NSLayoutConstraint.activate([
                    barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75 + widthOffset),
                    barView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue),
                    barView.heightAnchor.constraint(equalToConstant: thickness),
                    barView.widthAnchor.constraint(equalToConstant: sectionWidth),
                ])
          
                
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
                label.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -yValue)
            ])

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

