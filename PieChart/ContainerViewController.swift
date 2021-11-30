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
 
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150.0).isActive = true
 
        let chart: ChartView

        switch chartDataSet.ChartType {
        case .Pie:
            chart = PieChartView(
                frame: CGRect(x: 0, y: 0, width: 320, height: 320),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            chart.widthAnchor.constraint(equalToConstant: 320).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

        case .Vertical:
            chart = VerticalChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            chart.widthAnchor.constraint(equalToConstant: 720).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true

        case .Horizontal:
            chart = HorizontalChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            chart.widthAnchor.constraint(equalToConstant: 320).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 720).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

        case .VerticalGrouped:
            chart = VerticalGroupedChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            chart.widthAnchor.constraint(equalToConstant: 720).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true

        case .HorizontalGrouped:
            return
        case .VerticalStacked:
            return
        case .HorizontalStacked:
            return
        }

        scrollView.addSubview(chart)
        chart.bind(dataSet: chartDataSet)
  
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        chart.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        chart.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        chart.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
      
    }
}
