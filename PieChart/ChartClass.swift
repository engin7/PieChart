//
//  ChartClass.swift
//  PieChart
//
//  Created by Engin KUK on 12/5/21.
//

import UIKit

class ChartClass: UIView {
    var sum: Double = 0
    let thickness: CGFloat
    let gap: CGFloat

    let colors: [UIColor]
    let strokeWidth: CGFloat
    let borderColor: UIColor
    let vc: ContainerViewController

    // MARK: - Initializers

    init(_ vc: ContainerViewController, frame: CGRect, colors: [UIColor]? = nil, strokeWidth: CGFloat = 0, borderColor: UIColor = .black, thickness: CGFloat = 0, gap: CGFloat = 0) {
        self.thickness = thickness
        self.gap = gap
        self.colors = colors ?? [UIColor.gray]
        self.strokeWidth = strokeWidth
        self.borderColor = borderColor
        self.vc = vc
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func viewTapped(sender: UITapGestureRecognizer){
        guard let unwrappedView = sender.view as? BarView else { return }
        vc.barLabel.text = unwrappedView.myViewValue ?? "Not available"
    }
}
 
