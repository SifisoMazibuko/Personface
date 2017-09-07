//
//  PersonFaceView.swift
//  PersonFace
//
//  Created by Sifiso Mazibuko on 2017/09/06.
//  Copyright © 2017 Sifiso Mazibuko. All rights reserved.
//

import UIKit

@IBDesignable class PersonFaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var colorforHead: UIColor = .brown { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var colorforEyes: UIColor = .blue { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var colorforNose: UIColor = .green { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var colorforMouth: UIColor = .cyan { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 0.9  { didSet{ setNeedsDisplay() } }
    @IBInspectable
    private var eyesOpen: Bool = true { didSet{ setNeedsDisplay()}}
    private var beizerPath = UIBezierPath()
    private var fullCircle = CGFloat.pi
    private var circleCenter: CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    private var headRadius: CGFloat{
        return min(bounds.size.width,bounds.size.height) / 2 * scale
    }
    private enum Eye {
        case right
        case left
    }
    private func roundHead() -> UIBezierPath {
        beizerPath = UIBezierPath(arcCenter: circleCenter, radius: headRadius, startAngle: 0, endAngle: 2 * fullCircle , clockwise: false)
        beizerPath.lineWidth = lineWidth
        colorforHead.set()
        return beizerPath
    }
    //Path for both eyes
    private func eyes(_ eye: PersonFaceView.Eye) -> UIBezierPath {
        func CenterOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffSet = headRadius / Constants.EyeOffSet
            var eyeCenter = circleCenter
            eyeCenter.y -= eyeOffSet
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffSet
            return eyeCenter
        }
        let eyeCenter = CenterOfEye(eye)
        let eyeRadius = headRadius / Constants.EyeRadius
        if eyesOpen {
            beizerPath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: fullCircle * 2, clockwise: true)
        }else{
            beizerPath.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            beizerPath.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        beizerPath.lineWidth = lineWidth
        colorforEyes.set()
        return beizerPath
    }
    //Path for nose
    func nose() -> UIBezierPath {
        let height = circleCenter.y
        let width = circleCenter.x
        beizerPath = UIBezierPath()
        
        beizerPath.move(to: CGPoint(x: bounds.midX, y: bounds.midY))
        beizerPath.addLine(to: CGPoint(x: width + 50, y: height + 50))
        beizerPath.addLine(to: CGPoint(x: width - 50, y: height + 50))
        beizerPath.close()
        beizerPath.lineWidth = lineWidth
        colorforNose.setFill()
        return beizerPath
    }
    //Path for mouth
    func mouth() -> UIBezierPath {
        let width = headRadius / Constants.MouthWidth
        let height = headRadius / Constants.MouthHeight
        let offSet = headRadius / Constants.MouthOffSet
        let mouthLine = CGRect(x: circleCenter.x - width / 2, y: circleCenter.y + offSet, width: width, height: height)
        let startPoint =  CGPoint(x: mouthLine.minX, y: mouthLine.midY)
        let endPoint = CGPoint(x: mouthLine.maxX, y: mouthLine.midY)
        let smileOffSet = CGFloat(max(-1,min(Constants.MouthCurve, 1))) * mouthLine.height
        let cp1 = CGPoint(x: startPoint.x + mouthLine.width / 3, y: startPoint.y + smileOffSet)
        let cp2 = CGPoint(x: endPoint.x - mouthLine.width / 3, y: startPoint.y + smileOffSet)
        
        //beizerPath = UIBezierPath(rect: mouthLine)
        beizerPath.move(to: startPoint)
        beizerPath.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        beizerPath.lineWidth = lineWidth
        return beizerPath
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        roundHead().stroke()
        eyes(.left).stroke()
        eyes(.right).stroke()
        nose().fill()
        mouth().stroke()
    }
    func ZoomInOut(_ recognizer:UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1
        default:
            break
        }
    }
    
    func tapToOpenEyes(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
             break
        default:
            break
        }
    }
    
    struct Constants {
        static let EyeOffSet: CGFloat = 3
        static let EyeRadius: CGFloat = 10
        static let MouthOffSet: CGFloat = 2.5
        static let MouthWidth: CGFloat = 1
        static let MouthHeight: CGFloat = 5
        static let MouthCurve: Double = 1.0
    }
}
