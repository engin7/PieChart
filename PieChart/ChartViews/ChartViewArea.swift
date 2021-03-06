//
//  ChartClass.swift
//  PieChart
//
//  Created by Engin KUK on 12/5/21.
//

import UIKit


typealias ChartViewArea =  ProtocolChart & ChartClass

protocol ProtocolChart {
    func bind(dataSet: ChartDataSet)
}

class ChartClass: UIView {
    var sum: Double = 0
    let thickness: CGFloat
    let gap: CGFloat

    let colors: [UIColor]
    let strokeWidth: CGFloat
    let borderColor: UIColor
    let vc: ContainerViewController
    var markerView: ChartMarkerView?
    
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
         
        guard let seriesPoint =  unwrappedView.seriesPoint else { return }
        guard let point = unwrappedView.point else { return }
        let color = unwrappedView.color ?? UIColor.lightGray

        // convert relative point to screen at that moment
        let p =  unwrappedView.convert(point, to: vc.view)

        
        let bundle = ShowChartMarkerBundle(seriesPoint: seriesPoint, color: color, point: p)
        
        markerView?.show(bundle: bundle)
 
        UIView.animate(withDuration: 0.3,//Time duration
                            delay:0.0,
                            options:[.allowUserInteraction, .curveEaseInOut],
                            animations: { unwrappedView.alpha = 0.5  },
                            completion: { _ in unwrappedView.alpha = 1 })
        
    }
}
 
