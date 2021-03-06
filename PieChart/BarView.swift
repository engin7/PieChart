//
//  Views.swift
//  PieChart
//
//  Created by Engin KUK on 6.12.2021.
//

import UIKit.UIView
 
class BarView: UIView {
    var color: UIColor?
    var seriesPoint: AxisData?
    var point: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 1
//        layer.shadowOffset = CGSize(width: 1.0, height: -2.0)
//        layer.shadowRadius = 2
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
