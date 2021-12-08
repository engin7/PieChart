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
        let dataSet = ChartDataSet(ChartType: .Line, data: globaChartData)
        pushVC(with: dataSet)
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
 
