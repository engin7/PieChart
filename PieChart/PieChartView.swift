//
//  PieChartView.swift
//  PieChart
//
//  Created by Engin KUK on 25.11.2021.
//
 
import UIKit

class PieChartView: UIView {
    // MARK: - Data
    
    private var data: [(String, CGFloat)] = []
        
    func set(data: [String:Float]) {
        let sum = data.compactMap{ $0.value }.reduce(0, +)
        self.data = sum == 0 ? data.map{ ($0.0, CGFloat($0.1)) } : data.map{ ($0.0, CGFloat($0.1 / sum)) }.sorted(by: { $0.1 > $1.1 })
    }
    
    // MARK: - Initializers
    
    init(frame: CGRect, colors: [UIColor]? = nil, strokeWidth: CGFloat = 0, borderColor: UIColor = .black) {
        super.init(frame: frame)
        
        self.colors = colors ?? self.colors
        self.strokeWidth = strokeWidth
        self.borderColor = borderColor
        
        self.backgroundColor = .clear
         
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Touch
    
    @objc private func tapGestureRecognized(_ recognizer: UITapGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizer.State.ended {
            
            let location = recognizer.location(in: self)
            
            let touchDistanceToCenter = distanceToCenter(location)
            guard touchDistanceToCenter <= radius else  { return } // outside the chart
            
            let c = CGPoint(x: 0.5*frame.width, y: 0.5*frame.height)
            
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
    
    var colors: [UIColor] = [UIColor.gray]
    var strokeWidth: CGFloat = 0
    var borderColor = UIColor.black
    var radius: CGFloat = 0
    var touchPoint: CGPoint = CGPoint.zero
    var flag = false
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
         
        
        let center = CGPoint(x: 0.5*rect.width, y: 0.5*rect.height)
        
        var accumulatedAngle: CGFloat = -0.5 * CGFloat.pi
        var i: Int = 0
        
        borderColor.setStroke()
        context.setLineWidth(strokeWidth)
        
        data.forEach { (key, value) in
            let angle = value * 2 * CGFloat.pi
            radius = min(0.5*rect.width - 10, 0.5*rect.height - 10) - 0.5 * strokeWidth

            let startAngle = -accumulatedAngle
            let endAngle =  startAngle - angle
      
            let convertedStartAngle =  (accumulatedAngle + 0.5 * CGFloat.pi).degrees
            let convertedEndAngle = (0.5 * CGFloat.pi + accumulatedAngle + angle).degrees
 
//            print("### \(i)")
//            print(convertedStartAngle.degrees)
//            print(convertedEndAngle.degrees)
//            print("#touch#")

            // create path
            let path = CGMutablePath()
            path.move(to: CGPoint())
            
            
            var inBeetween: Bool = false
            
          print("#anlges## \(i)")
            
            let touchAngle =  atan2(center.y - touchPoint.y, touchPoint.x - center.x)
            
            let convertedTouchAngle = (0.5 * CGFloat.pi - touchAngle).degrees
            
 
            if touchPoint != CGPoint.zero {
                if (convertedTouchAngle > convertedStartAngle && convertedTouchAngle < convertedEndAngle)  {
                    inBeetween = true
                }
            }
          
       
              if inBeetween {
                  radius = min(0.5*rect.width, 0.5*rect.height) - 0.5 * strokeWidth
              } else {
                  radius = min(0.5*rect.width - 10, 0.5*rect.height - 10) - 0.5 * strokeWidth
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
            context.fillPath()
            context.addPath(path)

            context.strokePath()
               
        
            if !flag {
                let midPointAngle = ((startAngle + endAngle) / 2.0)
                let midPoint = CGPoint(x: center.x + 0.7 * radius * cos(midPointAngle), y: center.y - 0.7 * radius * sin(midPointAngle))
                
                addLabel(midPoint, key)
            }
           
            context.restoreGState()
 
            accumulatedAngle += angle
            i = i >= colors.count ? 0 : i + 1
        }
        let _tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        self.addGestureRecognizer(_tapGestureRecognizer)
        flag = true
    }
     
    func addLabel(_ midPoint: CGPoint, _ title: String) {
            let label = UILabel()
            label.text = title
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
        
            label.centerXAnchor.constraint(equalTo: leadingAnchor, constant: midPoint.x).isActive = true
            label.centerYAnchor.constraint(equalTo: topAnchor, constant: midPoint.y).isActive = true
    }
    
    func resizepath(_ frame: CGRect , _ path: CGPath) -> CGPath{


                let boundingBox = path.boundingBox
                let boundingBoxAspectRatio = boundingBox.width / boundingBox.height
                let viewAspectRatio = frame.width  / frame.height
                var scaleFactor : CGFloat = 1.5
                if (boundingBoxAspectRatio > viewAspectRatio) {
                    // Width is limiting factor

                    scaleFactor = frame.width / boundingBox.width
                } else {
                    // Height is limiting factor
                    scaleFactor = frame.height / boundingBox.height
                }


                var scaleTransform = CGAffineTransform.identity
                scaleTransform = scaleTransform.scaledBy(x: scaleFactor, y: scaleFactor)
                scaleTransform.translatedBy(x: -boundingBox.minX, y: -boundingBox.minY)

            let scaledSize = boundingBox.size.applying(CGAffineTransform (scaleX: scaleFactor, y: scaleFactor))
           let centerOffset = CGSize(width: (frame.width - scaledSize.width ) / scaleFactor * 2.0, height: (frame.height - scaledSize.height) /  scaleFactor * 2.0 )
            scaleTransform = scaleTransform.translatedBy(x: centerOffset.width, y: centerOffset.height)
            //CGPathCreateCopyByTransformingPath(path, &scaleTransform)
            let  scaledPath = path.copy(using: &scaleTransform)


            return scaledPath!
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
 
