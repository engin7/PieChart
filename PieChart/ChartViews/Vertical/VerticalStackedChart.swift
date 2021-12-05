//
//  VerticalStackedChart.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//
 
import UIKit

class VerticalStackedChart: ChartView {
    
    typealias ChartModel = (String, [(String, Double)])
    
    private var data: [ChartModel] = []
    private var sum: Double = 0
    private let thickness : CGFloat
    private let gap : CGFloat

    private let colors: [UIColor]
    private let strokeWidth: CGFloat
    private let borderColor: UIColor
    private let vc: ContainerViewController

    func bind(dataSet: ChartDataSet) {
        
        let chartData = dataSet.data
        sum = chartData.compactMap({$0.seriesPoints.compactMap({ $0.value}).reduce(0, +)}).reduce(0, +)
        for j in 0...chartData[0].seriesPoints.count - 1 {
            let points: ChartModel =  (chartData[0].seriesPoints.map({ ($0.label) })[j], (chartData.map({ ( $0.seriesName, $0.seriesPoints.map({ ($0.value / sum) })[j]) })  ))
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
        let maxHeight = ((rect.height - 75) / maxRatio)
        let maxValue: Double = maxRatio * sum
        vc.addValuesYAxis(maxValue)
  
        var i: Int = 0
        var j: Int = 0

        borderColor.setStroke()
 

        data.forEach { key, mData in

            
            var heightOffset: CGFloat = 0
            let distanceAmongBars = (thickness + gap)
            let xValue: CGFloat = (CGFloat(i) * distanceAmongBars) + (gap + 0.5*thickness)

            mData.forEach { _, value in

                let sectionHeight = value * maxHeight 
          
                // create bar views
                let barView = UIView()
                barView.backgroundColor = colors[j]
                barView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(barView)
                
                NSLayoutConstraint.activate([
                    barView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -heightOffset-50),
                    barView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xValue),
                    barView.heightAnchor.constraint(equalToConstant: sectionHeight),
                    barView.widthAnchor.constraint(equalToConstant: thickness)
                ])
                
                if j == mData.count - 1 {
                    barView.layer.cornerRadius = thickness / .pi
                    barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                }
                
                barView.layer.shadowColor = UIColor.black.cgColor
                barView.layer.shadowOpacity = 1
                barView.layer.shadowOffset = CGSize(width: 1.0, height: -2.0)
                barView.layer.shadowRadius = 2
             
                heightOffset += sectionHeight
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
        
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
            label.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xValue).isActive = true
            label.topAnchor.constraint(equalTo: bottomAnchor, constant: -45).isActive = true

            i = i >= colors.count ? 0 : i + 1
        }
     
    }
 
     
}

