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

        let chart: ChartView

        switch chartDataSet.ChartType {
        case .Pie:
            chart = PieChartView(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            chart.widthAnchor.constraint(equalToConstant: 320).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
        case .Vertical:
            chart = VerticalChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            chart.widthAnchor.constraint(equalToConstant: 720).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
        case .Horizontal:
            chart = HorizontalChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            chart.widthAnchor.constraint(equalToConstant: 320).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 720).isActive = true
        case .VerticalGrouped:
            chart = VerticalGroupedChart(
                frame: CGRect(x: 0, y: 0, width: 100, height: 15),
                colors: [.yellow, .red, .orange, .brown, .purple, .cyan, .lightGray, .blue, .red, .orange, .brown, .purple],
                strokeWidth: 0)
            chart.widthAnchor.constraint(equalToConstant: 720).isActive = true
            chart.heightAnchor.constraint(equalToConstant: 320).isActive = true
        case .HorizontalGrouped:
            return
        case .VerticalStacked:
            return
        case .HorizontalStacked:
            return
        }

        chart.bind(dataSet: chartDataSet)

        // add the scroll view to self.view
        view.addSubview(scrollView)

        // constrain the scroll view to 8-pts on each side
        if chart is HorizontalChart {
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        } else {
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        }
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150.0).isActive = true

        // add labelOne to the scroll view
        scrollView.addSubview(chart)

        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        chart.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        chart.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        chart.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
      
    }
}
