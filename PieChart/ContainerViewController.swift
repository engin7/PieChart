//
//  ContainerViewController.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//

import UIKit

class ContainerViewController: UIViewController {
    var chartDataSet: ChartDataSet!
    let labelCount: Int = UIDevice.current.userInterfaceIdiom == .pad ? 8 : 4
    let thickness: CGFloat = 20
    let gap: CGFloat = 20

    let sampleColors: [UIColor] = [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple]

    let chartContainerView: UIView = {
       $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.bounces = false
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        return v
    }()

    let markerView: ChartMarkerView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(ChartMarkerView())
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        view.addSubview(markerView)
        view.addSubview(chartContainerView)
        
        NSLayoutConstraint.activate([
            chartContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            chartContainerView.leadingAnchor.constraint(equalTo:  view.leadingAnchor),
            chartContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
        
        chartContainerView.addSubview(scrollView)

        let frameLayoutGuide = scrollView.frameLayoutGuide
        let contentLayoutGuide = scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            frameLayoutGuide.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor),
            frameLayoutGuide.topAnchor.constraint(equalTo: chartContainerView.safeAreaLayoutGuide.topAnchor),
            markerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            markerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            markerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            markerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        let chart: ChartViewArea

        guard let seriesData = globaChartData.first else { return }
        let itemCount = seriesData.seriesPoints.count

        switch chartDataSet.ChartType {
        case .Pie:
            chart = PieChartView(
                self,
                frame: CGRect.zero,
                colors: sampleColors,
                strokeWidth: 0.0
            )

            NSLayoutConstraint.activate([
                frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])

        case .Line:
            
            chart =  LineChart(
                self,
                frame: CGRect.zero,
                colors: sampleColors,
                strokeWidth: 0,
                thickness: thickness,
                gap: gap * 2)
                
                  
            let distanceAmongBars = (thickness + gap * 2)
            let dynamicWidth = (CGFloat(itemCount) * distanceAmongBars) + gap
            chart.widthAnchor.constraint(equalToConstant: dynamicWidth).isActive = true
             drawAxisesForVertical()
            
        case .Vertical:
            chart = VerticalChart(
                self,
                frame: CGRect.zero,
                colors: sampleColors,
                strokeWidth: 0,
                thickness: thickness,
                gap: gap * 2)

            let distanceAmongBars = (thickness + gap * 2)
            let dynamicWidth = (CGFloat(itemCount) * distanceAmongBars) + gap
            chart.widthAnchor.constraint(equalToConstant: dynamicWidth).isActive = true
            drawAxisesForVertical()
        case .Horizontal:
            chart = HorizontalChart(self, frame: CGRect.zero,
                                    colors: sampleColors, strokeWidth: 0, thickness: thickness, gap: gap)
            let distanceAmongBars = (thickness + gap)
            let dynamicHeight = (CGFloat(itemCount) * distanceAmongBars) + gap
            chart.heightAnchor.constraint(equalToConstant: dynamicHeight).isActive = true
            drawAxisesForHorizontal()
        case .VerticalGrouped:
            chart = VerticalGroupedChart(self, frame: CGRect.zero, colors: sampleColors,
                                         strokeWidth: 0, thickness: thickness, gap: gap)
           
            let barAndGap = (thickness + gap)
         
            let distanceAmongBars: CGFloat = (CGFloat(globaChartData.count-1) * barAndGap) + (barAndGap + 0.5 * thickness)
            let distanceAmongGroups: CGFloat = CGFloat(itemCount-1) * (barAndGap + 0.5 * thickness) * CGFloat(globaChartData.count)

            let dynamicWidth = distanceAmongBars + distanceAmongGroups + barAndGap
            
            chart.widthAnchor.constraint(equalToConstant: dynamicWidth).isActive = true
            drawAxisesForVertical()
        case .HorizontalGrouped:
            chart = HorizontalGroupedChart(self, frame: CGRect.zero, colors: sampleColors, strokeWidth: 0, thickness: thickness, gap: gap)
            let barAndGap = (thickness + gap)
         
            let distanceAmongBars: CGFloat = (CGFloat(globaChartData.count-1) * barAndGap) + (barAndGap + 0.5 * thickness)
            let distanceAmongGroups: CGFloat = CGFloat(itemCount-1) * (barAndGap + 0.5 * thickness) * CGFloat(globaChartData.count)

            let dynamicHeight = distanceAmongBars + distanceAmongGroups + barAndGap
            chart.heightAnchor.constraint(equalToConstant: dynamicHeight).isActive = true
            drawAxisesForHorizontal()
        case .VerticalStacked:
            chart = VerticalStackedChart(
                self,
                frame: CGRect.zero,
                colors: sampleColors,
                strokeWidth: 0,
                thickness: thickness,
                gap: gap * 2)

            let distanceAmongBars = (thickness + gap * 2)
            let dynamicWidth = (CGFloat(itemCount) * distanceAmongBars) + gap
            chart.widthAnchor.constraint(equalToConstant: dynamicWidth).isActive = true
            drawAxisesForVertical()

        case .HorizontalStacked:
            chart = HorizontalStackedChart(self, frame: CGRect.zero, colors: sampleColors, strokeWidth: 0, thickness: thickness, gap: gap)

            let distanceAmongBars = (thickness + gap)
            let dynamicHeight = (CGFloat(itemCount) * distanceAmongBars) + gap
            chart.heightAnchor.constraint(equalToConstant: dynamicHeight).isActive = true
            drawAxisesForHorizontal()
     
        }
        chart.bind(dataSet: chartDataSet)
        chart.markerView = markerView
        
        scrollView.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor).isActive = true
        chart.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor).isActive = true
        chart.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor).isActive = true
        chart.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor).isActive = true

        // we want min sizes to as big as frame layout
        chart.heightAnchor.constraint(greaterThanOrEqualTo: frameLayoutGuide.heightAnchor, constant: 0.0).isActive = true
        chart.widthAnchor.constraint(greaterThanOrEqualTo: frameLayoutGuide.widthAnchor, constant: 0.0).isActive = true
    }

    lazy var horizontalLineView: UIView = {
        $0.backgroundColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())

    lazy var verticalLineView: UIView = {
        $0.backgroundColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())

    func drawAxisesForVertical() {
        let frameLayoutGuide = scrollView.frameLayoutGuide

        NSLayoutConstraint.activate([
            frameLayoutGuide.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: 70),
            frameLayoutGuide.bottomAnchor.constraint(equalTo: chartContainerView.safeAreaLayoutGuide.bottomAnchor),
        ])

        view.addSubview(horizontalLineView)
        view.addSubview(verticalLineView)

        NSLayoutConstraint.activate([
            horizontalLineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            horizontalLineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            horizontalLineView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            horizontalLineView.heightAnchor.constraint(equalToConstant: 2),
            verticalLineView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            verticalLineView.bottomAnchor.constraint(equalTo: horizontalLineView.bottomAnchor),
            verticalLineView.trailingAnchor.constraint(equalTo: horizontalLineView.leadingAnchor),
            verticalLineView.widthAnchor.constraint(equalToConstant: 2),
        ])
    }

    func drawAxisesForHorizontal() {
        let frameLayoutGuide = scrollView.frameLayoutGuide

        NSLayoutConstraint.activate([
            frameLayoutGuide.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor),
            frameLayoutGuide.bottomAnchor.constraint(equalTo: chartContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])

        view.addSubview(horizontalLineView)
        view.addSubview(verticalLineView)

        NSLayoutConstraint.activate([
            horizontalLineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 75),
            horizontalLineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25),
            horizontalLineView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            horizontalLineView.heightAnchor.constraint(equalToConstant: 2),
            verticalLineView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            verticalLineView.bottomAnchor.constraint(equalTo: horizontalLineView.bottomAnchor),
            verticalLineView.trailingAnchor.constraint(equalTo: horizontalLineView.leadingAnchor),
            verticalLineView.widthAnchor.constraint(equalToConstant: 2),
        ])
    }

    func roundToDouble(_ x: Double, roundTo: Double) -> Double {
        return Double(roundTo) * Double(round(x / roundTo))
    }
    
    func addValuesXAxis(_ maxValue: Double) {
        let rate: Double = roundToDouble(maxValue, roundTo: 5) / Double(labelCount)
        let offSet = 0.95 * (scrollView.frameLayoutGuide.layoutFrame.width - 98) / CGFloat(labelCount)

        for i in 1 ... labelCount {
            let seperatorView = UIView()
            seperatorView.backgroundColor = .gray
            seperatorView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(seperatorView)

            let label = UILabel()
            label.font = label.font.withSize(12)
         
            label.text = String((rate * Double(i)*100).rounded()/100)
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)

            NSLayoutConstraint.activate([
                seperatorView.trailingAnchor.constraint(equalTo: horizontalLineView.leadingAnchor, constant: CGFloat(i) * offSet),
                seperatorView.topAnchor.constraint(equalTo: horizontalLineView.bottomAnchor),
                seperatorView.heightAnchor.constraint(equalToConstant: 5),
                seperatorView.widthAnchor.constraint(equalToConstant: 1),
                label.centerXAnchor.constraint(equalTo: seperatorView.centerXAnchor),
                label.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 5),
            ])
        }
    }

    func addValuesYAxis(_ maxValue: Double) {
        let rate: Double =  roundToDouble(maxValue, roundTo: 5) / Double(labelCount)
        let offSet = 0.95 * (scrollView.frameLayoutGuide.layoutFrame.height - 48) / CGFloat(labelCount)
        print(offSet)
        // draw notches and add values
        for i in 1 ... labelCount {
            let seperatorView = UIView()
            seperatorView.backgroundColor = .gray
            seperatorView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(seperatorView)

            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = String((rate * Double(i)*100).rounded()/100)
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)

            NSLayoutConstraint.activate([
                seperatorView.bottomAnchor.constraint(equalTo: verticalLineView.bottomAnchor, constant: -CGFloat(i) * offSet),
                seperatorView.trailingAnchor.constraint(equalTo: verticalLineView.leadingAnchor),
                seperatorView.heightAnchor.constraint(equalToConstant: 1),
                seperatorView.widthAnchor.constraint(equalToConstant: 5),
                label.centerYAnchor.constraint(equalTo: seperatorView.centerYAnchor),
                label.trailingAnchor.constraint(equalTo: seperatorView.leadingAnchor, constant: -5),
            ])
        }
    }
}

extension ContainerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        markerView.scrolMarkerTo(scrollView)
    }
    
}
