//
//  PieChartView.swift
//  PieChart
//
//  Created by Engin KUK on 25.11.2021.
//
 
import UIKit

class PieChartView: ChartViewArea {
    // MARK: - Data
    
    private var data: [(String, CGFloat)] = []
        
    func bind(dataSet: ChartDataSet) {
        guard let seriesData = dataSet.data.first else { return }
        let series = seriesData.seriesPoints.sorted(by: { $0.index <  $1.index })
        sum = series.compactMap{ $0.value }.reduce(0, +)
        self.data = sum == 0 ? series.map{ ($0.label, CGFloat($0.value)) } : series.map{ ($0.label, CGFloat($0.value / sum)) }
    }
 
    // MARK: - Touch
    
    @objc private func tapGestureRecognized(_ recognizer: UITapGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizer.State.ended {
            
            let location = recognizer.location(in: self)
            
            let touchDistanceToCenter = distanceToCenter(location)
            guard touchDistanceToCenter <= radius else  { return } // outside the chart
                        
            touchPoint = location
            setNeedsDisplay()
        }
    }
    
    func distanceToCenter(_ location: CGPoint) -> CGFloat {
        let c = CGPoint(x: 0.5*frame.width, y: 0.5*frame.height)

        let x = location.x
        let y = location.y
        
        var dist = CGFloat(0.0)

        var xDist = CGFloat(0.0)
        var yDist = CGFloat(0.0)

        if x > c.x
        {
            xDist = x - c.x
        }
        else
        {
            xDist = c.x - x
        }

        if y > c.y
        {
            yDist = y - c.y
        }
        else
        {
            yDist = c.y - y
        }

        // pythagoras
        dist = sqrt(pow(xDist, 2.0) + pow(yDist, 2.0))
        return dist
    }
    
    
    // MARK: - Aesthetics
 
    var radius: CGFloat = 0
    var touchPoint: CGPoint = CGPoint.zero
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
         
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var accumulatedAngle: CGFloat = -0.5 * CGFloat.pi
        var i: Int = 0
        
        borderColor.setStroke()
        
        data.forEach { (key, value) in
            let angle = value * 2 * CGFloat.pi
            radius = min(0.4*rect.width, 0.4*rect.height)
 
            let convertedStartAngle =  (accumulatedAngle + 0.5 * CGFloat.pi).degrees
            let convertedEndAngle = (0.5 * CGFloat.pi + accumulatedAngle + angle).degrees
 
            // create path
            let path = CGMutablePath()
            path.move(to: CGPoint())
             
            var inBeetween: Bool = false
            let touchAngle =  atan2(center.y - touchPoint.y, touchPoint.x - center.x)
            
            let convertedTouchAngle = (0.5 * CGFloat.pi - touchAngle).degrees
            
            //   need to convert to unit circle angles so we can decide the quadrant
            if touchPoint != CGPoint.zero {
                if (convertedTouchAngle > convertedStartAngle && convertedTouchAngle < convertedEndAngle)  {
                    inBeetween = true
                }
            }
          
       
            let shadowBlurRadius: CGFloat
             
             self.subviews.forEach {
                 if $0.tag == i { $0.removeFromSuperview() }
            }
            
              if inBeetween {
                  context.setLineWidth(0.0)
                  radius = min(0.45*rect.width, 0.45*rect.height)
                  shadowBlurRadius = 10
                  
                  // Add label
                  let startAngle = -accumulatedAngle
                  let endAngle =  startAngle - angle
                  let midPointAngle = (CGFloat.pi/2 - (startAngle + endAngle) / 2.0)
                  let midPoint = CGPoint(x: center.x + 0.7 * radius * cos(midPointAngle - 0.5 * .pi), y: center.y + 0.7 * radius * sin(midPointAngle - 0.5 * .pi))
                  let percentValue = Int(ceil(value*100))
                  
                  let label = PaddedLabel()
 
                  label.layer.cornerRadius = 5
                  label.layer.masksToBounds = true
                  label.backgroundColor =  colors[i]
                  label.tag = i
                  label.text = key + ": \(percentValue)%"
                  label.lineBreakMode = .byTruncatingMiddle
                  
                  let shadowView = UIView()
                  shadowView.layer.shadowColor = UIColor.black.cgColor
                  shadowView.layer.shadowRadius = 2.0
                  shadowView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                  shadowView.layer.shadowOpacity = 1.0
                  shadowView.translatesAutoresizingMaskIntoConstraints = false

                  addSubview(shadowView)
                  
                  shadowView.addSubview(label)
                  label.translatesAutoresizingMaskIntoConstraints = false

                  let labelWidth = label.intrinsicContentSize.width

                  NSLayoutConstraint.activate([
                      shadowView.heightAnchor.constraint(equalToConstant: 36),
                      shadowView.centerYAnchor.constraint(equalTo: self.topAnchor, constant: midPoint.y),
                      label.widthAnchor.constraint(lessThanOrEqualToConstant: rect.width - 20),
                      label.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
                      label.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
                      label.topAnchor.constraint(equalTo: shadowView.topAnchor),
                      label.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
                  ])

                  if midPoint.x + labelWidth < rect.width {
                      NSLayoutConstraint.activate([
                          shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: midPoint.x),
                          shadowView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -8),
                      ])
                  } else {
                      NSLayoutConstraint.activate([
                          shadowView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
                          shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
                      ])
                  }

                  
              } else {
                  context.setLineWidth(strokeWidth)
                  radius = min(0.4*rect.width, 0.4*rect.height)
                  shadowBlurRadius = 0
              }
            
            path.addLine(to: CGPoint(x: radius, y: 0))
            path.addRelativeArc(
                center: CGPoint(),
                radius: radius,
                startAngle: 0,
                delta: angle)
            path.closeSubpath()
            
            context.saveGState()
            
            context.translateBy(x: center.x, y: center.y)
            context.rotate(by: accumulatedAngle)
            // draw

            context.addPath(path)
            colors[i].setFill()
            
            /// Shadow Declarations
            let shadowOffset = CGSize(width: 0, height: 0)
             
            context.setShadow(offset: shadowOffset, blur: shadowBlurRadius,  color: UIColor.black.cgColor)
 
            
            context.fillPath()
            context.addPath(path)

            context.strokePath()
               
        
 
            
            context.restoreGState()
 
            accumulatedAngle += angle
            i = i >= colors.count ? 0 : i + 1
        }
        let _tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        self.addGestureRecognizer(_tapGestureRecognizer)
    }
 
}
 

extension CGFloat {
    var degrees: CGFloat {
        var d =  self * CGFloat(180) / .pi
        while d < 0 {
            d += 360
        }

        return d
    }
}
 
@IBDesignable
class PaddedLabel: UILabel {

    @IBInspectable var inset:CGSize = CGSize(width: 5, height: 5)

    var padding: UIEdgeInsets {
        var hasText:Bool = false
        if let t = self.text?.count, t > 0 {
            hasText = true
        }
        else if let t = attributedText?.length, t > 0 {
            hasText = true
        }

        return hasText ? UIEdgeInsets(top: inset.height, left: inset.width, bottom: inset.height, right: inset.width) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let p = padding
        let width = superContentSize.width + p.left + p.right
        let heigth = superContentSize.height + p.top + p.bottom
        return CGSize(width: width, height: heigth)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let p = padding
        let width = superSizeThatFits.width + p.left + p.right
        let heigth = superSizeThatFits.height + p.top + p.bottom
        return CGSize(width: width, height: heigth)
    }
 
}


