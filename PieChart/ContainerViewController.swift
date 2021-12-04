//
//  ContainerViewController.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//

import UIKit

class ContainerViewController: UIViewController {
    var chartDataSet: ChartDataSet!
 
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
        
        let frameLayoutGuide = scrollView.frameLayoutGuide
        let contentLayoutGuide = scrollView.contentLayoutGuide

        let width = view.bounds.width
        let height = view.bounds.height
 
        NSLayoutConstraint.activate([
          frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.1 * height),
          frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0.2 * height)
        ])
       
        let chart: ChartView

        guard let seriesData = globaChartData.first else { return }
        let itemCount = seriesData.seriesPoints.count
        let thickness: CGFloat = 20
        
    
        switch chartDataSet.ChartType {
        case .Pie:
            chart = PieChartView(
                frame: CGRect(x: 0, y: 0, width: 320, height: 320),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 1.0)
      
            chart.widthAnchor.constraint(equalToConstant: width).isActive = true
            chart.heightAnchor.constraint(equalToConstant: width).isActive = true

        case .Vertical:
            chart = VerticalChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            
            let dynamicWidth = CGFloat(itemCount * 3) * thickness

            chart.widthAnchor.constraint(equalToConstant: dynamicWidth).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true

        case .Horizontal:
            chart = HorizontalChart(
                frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
 
            let dynamicHeight = CGFloat(itemCount) * 2.5 * thickness + 10
            chart.widthAnchor.constraint(equalToConstant: width).isActive = true
            chart.heightAnchor.constraint(equalToConstant: dynamicHeight).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

        case .VerticalGrouped:
            chart = VerticalGroupedChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0, thickness: thickness)
            
            let dynamicWidth = CGFloat(itemCount * 5) * thickness
            chart.widthAnchor.constraint(equalToConstant: dynamicWidth).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true

        case .HorizontalGrouped:
            chart = HorizontalGroupedChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            let dynamicHeight = CGFloat(itemCount) * 5 * thickness
            chart.widthAnchor.constraint(equalToConstant: 320).isActive = true
            chart.heightAnchor.constraint(equalToConstant: dynamicHeight).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        case .VerticalStacked:
            chart = VerticalStackedChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            
            let dynamicWidth = CGFloat(itemCount * 3) * thickness
            chart.widthAnchor.constraint(equalToConstant: dynamicWidth).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        case .HorizontalStacked:
            chart = HorizontalStackedChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
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
        chart.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor).isActive = true
    }
    
 
}
