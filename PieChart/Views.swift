//
//  Views.swift
//  PieChart
//
//  Created by Engin KUK on 6.12.2021.
//

import UIKit.UIView


typealias ChartView =  ProtocolChart & ChartClass

protocol ProtocolChart {
    func bind(dataSet: ChartDataSet)
}



class BarView: UIView {
    var myViewValue: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1.0, height: -2.0)
        layer.shadowRadius = 2
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
