//
//  ChartMarkerArea.swift
//  CAChartLib
//
//  Created by CloudApper1 on 29.11.2021.
//  Copyright © 2021 M2SYS Technology. All rights reserved.
//

import UIKit
 
class ChartMarkerView: UIView {
    var legendName: String?
    var seriesPoint: AxisData?
    var color: UIColor?
    var containerViewCenterConstraint: NSLayoutConstraint!
    var pointerViewCenterConstraint: NSLayoutConstraint!
    var pointerViewHeightConstraint: NSLayoutConstraint!
    
    private var legendLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.backgroundColor = .white
        return lbl
    }()
    
    private var valueLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.backgroundColor = .white
        return lbl
    }()
    
    
    private var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var pointerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        let defaultPadding:CGFloat = 10
        self.addSubview(pointerView)
        self.addSubview(containerView)
        containerView.addSubview(legendLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(seperatorView)
        
        containerViewCenterConstraint = containerView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        pointerViewCenterConstraint = pointerView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        pointerViewHeightConstraint = pointerView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerViewCenterConstraint,
            
            legendLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: defaultPadding),
            legendLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: defaultPadding),
            legendLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -defaultPadding),
            
            seperatorView.topAnchor.constraint(equalTo: containerView.topAnchor),
            seperatorView.leadingAnchor.constraint(equalTo: legendLabel.trailingAnchor, constant: defaultPadding),
            seperatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            seperatorView.widthAnchor.constraint(equalToConstant: 1),
            
            valueLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: defaultPadding),
            valueLabel.leadingAnchor.constraint(equalTo: seperatorView.trailingAnchor, constant: defaultPadding),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -defaultPadding),
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -defaultPadding),
            
            
            pointerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: defaultPadding * 2),
            pointerView.widthAnchor.constraint(equalToConstant: 2),
            pointerViewHeightConstraint,
            pointerViewCenterConstraint,
        ])
        
    }
    
    func show(bundle: ShowChartMarkerBundle) {
        self.seriesPoint = bundle.seriesPoint
        self.color = bundle.color
        legendLabel.text = self.seriesPoint?.label
        valueLabel.text = self.seriesPoint?.value.fractionDigits()
        containerView.layer.borderColor = self.color?.cgColor
        seperatorView.backgroundColor = self.color
        pointerView.backgroundColor = self.color
        moveContainerView(to: bundle.point)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [self] in
            self.containerView.isHidden = false
            self.pointerView.isHidden = false
        }
    }
    
    func hide() {
        containerView.isHidden = true
        pointerView.isHidden = true
    }
    
    func scrolMarkerTo(_ sv: UIScrollView) {
        pointerView.isHidden = true
    }
    
    private func moveContainerView(to point: CGPoint) {
        var diff = point.x - self.center.x
        if point.x - (containerView.bounds.width / 2) < 0 {
            diff = -((self.bounds.width / 2) - (containerView.bounds.width / 2))
        }else if point.x + (containerView.bounds.width / 2) > self.bounds.width {
            diff = ((self.bounds.width / 2) - (containerView.bounds.width / 2))
        }
        containerViewCenterConstraint.constant = diff
        
        var diffPointer = point.x - self.center.x
        if point.x - (pointerView.bounds.width / 2) < 0 {
            diffPointer = -((self.bounds.width / 2) - (pointerView.bounds.width / 2))
        }else if point.x + (pointerView.bounds.width / 2) > self.bounds.width {
            diffPointer = ((self.bounds.width / 2) - (pointerView.bounds.width / 2))
        }
        let minY = self.convert(pointerView.frame, to: nil).minY
        pointerViewHeightConstraint.constant = point.y - minY
        pointerViewCenterConstraint.constant = diffPointer
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
}


extension Formatter {
    static let number = NumberFormatter()
}

extension FloatingPoint {
    func fractionDigits(min: Int = 2, max: Int = 2, roundingMode: NumberFormatter.RoundingMode = .halfEven) -> String {
        Formatter.number.minimumFractionDigits = min
        Formatter.number.maximumFractionDigits = max
        Formatter.number.roundingMode = roundingMode
        Formatter.number.numberStyle = .decimal
        return Formatter.number.string(for: self) ?? ""
    }
}

struct ShowChartMarkerBundle {
    let seriesPoint: AxisData
    let color: UIColor
    let point: CGPoint
}
