

import UIKit

class DonutChartView: ChartViewArea {
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
            
            // if donut
            guard touchDistanceToCenter >= radius * 0.25 else  { return }
            
            touchPoint = location
            
            guard !labelFrame.contains(touchPoint) else { return }

            setNeedsDisplay()
        }
    }
    
    func distanceToCenter(_ location: CGPoint) -> CGFloat {
        let c = CGPoint(x: 0.5*bounds.width, y: 0.5*bounds.height)

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
    var labelFrame = CGRect.zero
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
         
        var accumulatedAngle: CGFloat = -0.5 * CGFloat.pi
        var i: Int = 0
        
        borderColor.setStroke()
        
        data.forEach { (key, value) in
            let angle = value * 2 * CGFloat.pi
            radius = min(0.4*rect.width, 0.4*rect.height)
 
            let convertedStartAngle =  (accumulatedAngle + 0.5 * CGFloat.pi).degrees
            let convertedEndAngle = (0.5 * CGFloat.pi + accumulatedAngle + angle).degrees
 
           
            var inBeetween: Bool = false
            let touchAngle =  atan2(center.y - touchPoint.y, touchPoint.x - center.x)
            
            let convertedTouchAngle = (0.5 * CGFloat.pi - touchAngle).degrees
            
            //   need to convert to unit circle angles so we can decide the quadrant
            if touchPoint != CGPoint.zero {
                if (convertedTouchAngle > convertedStartAngle && convertedTouchAngle < convertedEndAngle)  {
                    inBeetween = true
                }
            }
          
        
             self.subviews.forEach {
                 if $0.tag == i { $0.removeFromSuperview() }
            }
            
              if inBeetween {
                  radius = min(0.45*rect.width, 0.45*rect.height)
          
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
                  addSubview(shadowView)
                  
                  shadowView.addSubview(label)
                  label.translatesAutoresizingMaskIntoConstraints = false
 
                  let labelWidth = label.intrinsicContentSize.width

                  NSLayoutConstraint.activate([
                      shadowView.widthAnchor.constraint(equalToConstant: labelWidth),
                      shadowView.heightAnchor.constraint(equalToConstant: 35),
                      shadowView.centerYAnchor.constraint(equalTo: self.topAnchor, constant: midPoint.y),
                      label.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
                      label.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
                      label.topAnchor.constraint(equalTo: shadowView.topAnchor),
                      label.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
                  ])

                  if midPoint.x + labelWidth < rect.width {
                      NSLayoutConstraint.activate([
                          shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: midPoint.x),
                          shadowView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -5),
                      ])
                  } else {
                      NSLayoutConstraint.activate([
                          shadowView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 5),
                          shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
                      ])
                  }
                   
                  layoutIfNeeded()
                  labelFrame = label.frame
                  
                  let param = SliceParameters(radius: radius, angle: angle, accumulatedAngle: accumulatedAngle, shadowBlurRadius: 10, color: colors[i])
                  drawSlices(param)
              } else {
                  radius = min(0.4*rect.width, 0.4*rect.height)
                  let param = SliceParameters(radius: radius, angle: angle, accumulatedAngle: accumulatedAngle, shadowBlurRadius: 0, color: colors[i])
                  drawSlices(param)
              }

            accumulatedAngle += angle
            i = i >= colors.count ? 0 : i + 1
        }
        addOverlayView()
        let _tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        self.addGestureRecognizer(_tapGestureRecognizer)
    }
    
    func addOverlayView() {
        // add overlay
        let radii = min(0.3*bounds.width, 0.3*bounds.height)
        let point = CGPoint(x: bounds.midX - radii/2, y: bounds.midY - radii/2)
        let size  = CGSize(width: radii, height: radii)
        let frame = CGRect(origin: point, size: size)
        
        let overlayView = UIView(frame: frame)
        overlayView.layer.cornerRadius = radii/2
        overlayView.backgroundColor = .white
        addSubview(overlayView)
        sendSubviewToBack(overlayView)
    }
 
    struct SliceParameters {
        let radius: CGFloat
        let angle: CGFloat
        let accumulatedAngle: CGFloat
        let shadowBlurRadius: CGFloat
        let color: UIColor
    }
    
    
    func drawSlices(_ param: SliceParameters) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // create path
        let path = CGMutablePath()
        path.move(to: CGPoint())
         
        path.addLine(to: CGPoint(x: radius, y: 0))
        path.addRelativeArc(
            center: CGPoint(),
            radius: radius,
            startAngle: 0,
            delta: param.angle)
     
        path.closeSubpath()
        
        context.saveGState()
        
        context.translateBy(x: center.x, y: center.y)
        context.rotate(by: param.accumulatedAngle)
        // draw

        context.addPath(path)
        param.color.setFill()
        
        /// Shadow Declarations
        let shadowOffset = CGSize(width: 0, height: 0)
         
        context.setShadow(offset: shadowOffset, blur: param.shadowBlurRadius,  color: UIColor.black.cgColor)

        
        context.fillPath()
        context.addPath(path)

        context.strokePath()
           
        context.restoreGState()
    }
    
    
    
}
 
 
