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

    let sampleColors: [UIColor] = [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple]
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.bounces = false
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false

        return v
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        masterVC = self

        view.addSubview(scrollView)
        
        drawAxises()
        
        let frameLayoutGuide = scrollView.frameLayoutGuide
        let contentLayoutGuide = scrollView.contentLayoutGuide
 
        NSLayoutConstraint.activate([
          frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
          frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
          frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
       
        let chart: ChartView

        guard let seriesData = globaChartData.first else { return }
        let itemCount = seriesData.seriesPoints.count
        let thickness: CGFloat = 20
       
        switch chartDataSet.ChartType {
        case .Pie:
            chart = PieChartView(
                frame: CGRect.zero,
                colors: sampleColors,
                strokeWidth: 1.0)
       
        case .Vertical:
            chart = VerticalChart(
                self,
                frame: CGRect.zero,
                colors: sampleColors,
                strokeWidth: 0)
            
            let dynamicWidth = CGFloat(itemCount * 3) * thickness
            chart.widthAnchor.constraint(equalToConstant: dynamicWidth).isActive = true
        
        case .Horizontal:
            chart = HorizontalChart(self, frame: CGRect.zero,
                colors: sampleColors,
                strokeWidth: 0)
 
            let dynamicHeight = CGFloat(itemCount) * 2.5 * thickness + 10
    
            chart.heightAnchor.constraint(equalToConstant: dynamicHeight).isActive = true

        case .VerticalGrouped:
            chart = VerticalGroupedChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: sampleColors,
                strokeWidth: 0, thickness: thickness)
            
            let dynamicWidth = CGFloat(itemCount * 5) * thickness
            chart.widthAnchor.constraint(equalToConstant: dynamicWidth).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true

        case .HorizontalGrouped:
            chart = HorizontalGroupedChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: sampleColors,
                strokeWidth: 0)
            let dynamicHeight = CGFloat(itemCount) * 5 * thickness
            chart.widthAnchor.constraint(equalToConstant: 320).isActive = true
            chart.heightAnchor.constraint(equalToConstant: dynamicHeight).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        case .VerticalStacked:
            chart = VerticalStackedChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: sampleColors,
                strokeWidth: 0)
            
            let dynamicWidth = CGFloat(itemCount * 3) * thickness
            chart.widthAnchor.constraint(equalToConstant: dynamicWidth).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        case .HorizontalStacked:
            chart = HorizontalStackedChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: sampleColors,
                strokeWidth: 0)
            let dynamicHeight = CGFloat(itemCount) * 2.5 * thickness + 10
            chart.widthAnchor.constraint(equalToConstant: 320).isActive = true
            chart.heightAnchor.constraint(equalToConstant: dynamicHeight).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        }
        chart.bind(dataSet: chartDataSet)

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
    
    func drawAxises() {
 
        view.addSubview(horizontalLineView)
        view.addSubview(verticalLineView)
        
        NSLayoutConstraint.activate([
            horizontalLineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 75),
            horizontalLineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: -25),
            horizontalLineView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50),
            horizontalLineView.heightAnchor.constraint(equalToConstant: 2),
            verticalLineView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            verticalLineView.bottomAnchor.constraint(equalTo: horizontalLineView.bottomAnchor),
            verticalLineView.trailingAnchor.constraint(equalTo: horizontalLineView.leadingAnchor),
            verticalLineView.widthAnchor.constraint(equalToConstant: 2)
        ])
    
    }
 
 
    func addValuesXLabel(_ maxValue: Double) {
     
        let rate: Int = roundToNumber(maxValue / Double(labelCount), roundTo: 5)
        let offSet = (scrollView.frameLayoutGuide.layoutFrame.width-125) / CGFloat(labelCount)

        for i in 1 ... labelCount {
            
            let seperatorView = UIView()
            seperatorView.backgroundColor = .gray
            seperatorView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(seperatorView)
             
            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = String(rate * i)
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)

            NSLayoutConstraint.activate([
                seperatorView.trailingAnchor.constraint(equalTo: horizontalLineView.leadingAnchor, constant: CGFloat(i) * offSet),
                seperatorView.topAnchor.constraint(equalTo: horizontalLineView.bottomAnchor),
                seperatorView.heightAnchor.constraint(equalToConstant: 5),
                seperatorView.widthAnchor.constraint(equalToConstant: 1),
                label.centerXAnchor.constraint(equalTo: seperatorView.centerXAnchor),
                label.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 5)
            ])
             
        }
    }
    
    
    func addValuesYLabel(_ maxValue: Double) {
      
        let rate: Int = roundToNumber(maxValue / Double(labelCount), roundTo: 5)
        let offSet = (scrollView.frameLayoutGuide.layoutFrame.height-75) / CGFloat(labelCount)
        print(offSet)
        // draw notches and add values
        for i in 1 ... labelCount {
            let seperatorView = UIView()
            seperatorView.backgroundColor = .gray
            seperatorView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(seperatorView)
            
            let label = UILabel()
            label.font = label.font.withSize(12)
            label.text = String(rate * i)
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
    
            NSLayoutConstraint.activate([
                seperatorView.bottomAnchor.constraint(equalTo: verticalLineView.bottomAnchor, constant: -CGFloat(i) * offSet),
                seperatorView.trailingAnchor.constraint(equalTo: verticalLineView.leadingAnchor),
                seperatorView.heightAnchor.constraint(equalToConstant: 1),
                seperatorView.widthAnchor.constraint(equalToConstant: 5),
                label.centerYAnchor.constraint(equalTo: seperatorView.centerYAnchor),
                label.trailingAnchor.constraint(equalTo: seperatorView.leadingAnchor, constant: -5)
            ])
        }
    }
    
    
    
}
