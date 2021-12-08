//
//  ViewController.swift
//  PieChart
//
//  Created by Engin KUK on 25.11.2021.
//

import UIKit

class ViewController: UIViewController {
    var vc: ContainerViewController!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController?
    }

    @IBAction func pieTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .Pie, data: globaChartData)
        pushVC(with: dataSet)
    }

    @IBAction func lineTouched(_ sender: Any) {
        let v = LineVC()
        navigationController?.pushViewController(v, animated: true)
    }

    @IBAction func horizontalTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .Horizontal, data: globaChartData)
        pushVC(with: dataSet)
    }

    @IBAction func horizontalGroupedTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .HorizontalGrouped, data: globaChartData)
        pushVC(with: dataSet)
    }

    @IBAction func horizontalStackedTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .HorizontalStacked, data: globaChartData)
        pushVC(with: dataSet)
    }

    @IBAction func verticalTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .Vertical, data: globaChartData)
        pushVC(with: dataSet)
    }

    @IBAction func verticalGroupedTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .VerticalGrouped, data: globaChartData)
        pushVC(with: dataSet)
    }

    @IBAction func verticalStackedTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .VerticalStacked, data: globaChartData)
        pushVC(with: dataSet)
    }

    func pushVC(with dataSet: ChartDataSet) {
        vc.chartDataSet = dataSet
        navigationController?.pushViewController(vc, animated: true)
    }
}


class LineVC: UIViewController {
    
    let lineChart = LineChart()
    
    override func viewDidLoad() {
          super.viewDidLoad()
        view.addSubview(lineChart)

        lineChart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineChart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineChart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineChart.topAnchor.constraint(equalTo: view.topAnchor),
            lineChart.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

         
        let f: (CGFloat) -> CGPoint = {
            let noiseY = (CGFloat(arc4random_uniform(2)) * 2 - 1) * CGFloat(arc4random_uniform(4))
            let noiseX = (CGFloat(arc4random_uniform(2)) * 2 - 1) * CGFloat(arc4random_uniform(4))
            let b: CGFloat = 5
            let y = 2 * $0 + b + noiseY
            return CGPoint(x: $0 + noiseX, y: y)
        }

        let xs = [Int](1 ..< 20)

        let points = xs.map({ f(CGFloat($0 * 10)) })

        lineChart.deltaX = 20
        lineChart.deltaY = 30
        
        lineChart.plot(points)
      }
}
