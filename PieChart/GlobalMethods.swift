//
//  GlobalMethods.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//

import UIKit

// Global Methods

func roundToNumber(_ x: Double, roundTo: Double) -> Int {
    return Int(roundTo) * Int(round(x / roundTo))
}

