//
//  ViewController.swift
//  PieChart
//
//  Created by Engin KUK on 25.11.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
    
    @IBAction func pieTouched(_ sender: Any) {
    }
    
    @IBAction func horizontalTouched(_ sender: Any) {
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func horizontalGroupedTouched(_ sender: Any) {
    }
    
    @IBAction func horizontalStackedTouched(_ sender: Any) {
    }
    
    @IBAction func verticalTouched(_ sender: Any) {
    }
    
    
    @IBAction func verticalGroupedTouched(_ sender: Any) {
    }
    
    @IBAction func verticalStackedTouched(_ sender: Any) {
    }
    
}
