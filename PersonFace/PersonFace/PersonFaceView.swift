//
//  PersonFaceView.swift
//  PersonFace
//
//  Created by Sifiso Mazibuko on 2017/09/06.
//  Copyright © 2017 Sifiso Mazibuko. All rights reserved.
//

import UIKit

@IBDesignable
class PersonFaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.9 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var fullCircle = CGFloat.pi
    @IBInspectable
    var colorforHead: UIColor = UIColor.brown {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var colorforEyes: UIColor = UIColor.blue {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var colorforNose: UIColor = UIColor.green {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var colorforMouth: UIColor = UIColor.cyan {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var lineWidth: CGFloat = 0.9  {
        didSet{
            setNeedsDisplay()
        }
    }
    
    private var CircleCenter: CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var HeadRadius: CGFloat{
        return min(bounds.size.width,bounds.size.height) / 2 * scale
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        RoundHead().stroke()
        Eyes(.left).stroke()
        Eyes(.right).stroke()
        Nose(rect).fill()
        Mouth().stroke()
    }
    
    private func RoundHead() -> UIBezierPath
    {
        let beizerPath = UIBezierPath(arcCenter: CircleCenter, radius: HeadRadius, startAngle: 0, endAngle: 2 * fullCircle , clockwise: false)
        
        beizerPath.lineWidth = lineWidth
        colorforHead.set()
        return beizerPath
    }
    enum Eye {
        case right
        case left
    }
    
    func Eyes(_ eye: PersonFaceView.Eye) -> UIBezierPath {
        func CenterOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffSet = HeadRadius / CGFloat(3)
            var eyeCenter = CircleCenter
            eyeCenter.y -= eyeOffSet
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffSet
            return eyeCenter
        }
        let eyeCenter = CenterOfEye(eye)
        let eyeRadius = HeadRadius / CGFloat(5)
        let eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: fullCircle * 2, clockwise: true)
        
        eyePath.lineWidth = lineWidth
        colorforEyes.set()
        return eyePath
    }
    
    func Nose(_ rect: CGRect) -> UIBezierPath {
        let height = CircleCenter.y
        let width = CircleCenter.x
        let nosePath = UIBezierPath()
        
        nosePath.move(to: CGPoint(x: bounds.midX, y: bounds.midY))
        nosePath.addLine(to: CGPoint(x: width + 50, y: height + 50))
        nosePath.addLine(to: CGPoint(x: width - 50, y: height + 50))
        
        nosePath.close()
        nosePath.lineWidth = lineWidth
        colorforNose.setFill()
        return nosePath
    }
    
    func Mouth() -> UIBezierPath {
        let width = HeadRadius / CGFloat(1)
        let height = HeadRadius / CGFloat(5)
        let offSet = HeadRadius / CGFloat(2.5)
        let mouthLine = CGRect(x: CircleCenter.x - width / 2, y: CircleCenter.y + offSet, width: width, height: height)
        let startPoint = CGPoint(x: mouthLine.minX, y: mouthLine.midX)
        let endPoint = CGPoint(x: mouthLine.maxX, y: mouthLine.midY)
        let smileOffset =  CGFloat(max(-1, min(Double(1.0),1))) * mouthLine.height
        let cPoint1 = CGPoint(x: startPoint.x + mouthLine.width / 3, y: startPoint.y + smileOffset)
        let cPoint2 = CGPoint(x: endPoint.y + mouthLine.width / 3, y: startPoint.y + smileOffset)
        let mouthPath = UIBezierPath(rect: mouthLine)
        mouthPath.move(to: startPoint)
        mouthPath.addCurve(to: CGPoint(x: mouthLine.minX, y: mouthLine.midY), controlPoint1: cPoint1, controlPoint2: cPoint2)
        
        
        mouthPath.lineWidth = lineWidth
        return mouthPath
    }
    
    
    func ZoomInOut(_ recognizer:UIPinchGestureRecognizer){
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1
        default:
            break
        }
    }
}
