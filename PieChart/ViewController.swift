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
        vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController?
    }
     
    
    @IBAction func pieTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .Pie, data: globaChartData)
        vc.chartDataSet = dataSet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func horizontalTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .Horizontal, data: globaChartData)
        vc.chartDataSet = dataSet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func horizontalGroupedTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .HorizontalGrouped, data: globaChartData)
        vc.chartDataSet = dataSet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func horizontalStackedTouched(_ sender: Any) {
    }
    
    @IBAction func verticalTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .Vertical, data: globaChartData)
        vc.chartDataSet = dataSet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func verticalGroupedTouched(_ sender: Any) {
        let dataSet = ChartDataSet(ChartType: .VerticalGrouped, data: globaChartData)
        vc.chartDataSet = dataSet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func verticalStackedTouched(_ sender: Any) {
    }
    
}
