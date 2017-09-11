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
    var colorforHead: UIColor = .yellow { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var colorforEyes: UIColor = .blue { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var colorforEyeIris: UIColor = .blue { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var colorforNose: UIColor = .green { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var colorforMouth: UIColor = .darkGray { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var colorforEyeBrows: UIColor = .black { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 1.5  { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var eyeLashWidth: CGFloat = 2  { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var eyesOpen: Bool = true { didSet{ setNeedsDisplay()}}
    @IBInspectable
    var MouthCurve: Double = 1.0
    private var beizerPath = UIBezierPath()
    private var fullCircle = CGFloat.pi
    private var circleCenter: CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    private var headRadius: CGFloat{
        return min(bounds.size.width,bounds.size.height) / 2 * scale
    }
    private struct Constants {
        static let EyeOffSet: CGFloat = 3
        static let EyeRadius: CGFloat = 10
        static let MouthOffSet: CGFloat = 2.5
        static let MouthWidth: CGFloat = 1
        static let MouthHeight: CGFloat = 5
        static let NoseOffSet:  CGFloat = 30
    }
    private enum Eye {
        case right
        case left
    }
    private enum EyeBrows {
        case right
        case left
    }
    
    private func roundHead() -> UIBezierPath {
        beizerPath = UIBezierPath(arcCenter: circleCenter, radius: headRadius, startAngle: 0, endAngle: 2 * fullCircle , clockwise: false)
        beizerPath.lineWidth = lineWidth
        colorforHead.set()
        return beizerPath
    }
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
        return beizerPath
    }
    private func eyesIris(_ iris: PersonFaceView.Eye) -> UIBezierPath {
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffSet = headRadius / Constants.EyeOffSet
            var eyeCenter = circleCenter
            eyeCenter.y -= eyeOffSet
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffSet
            return eyeCenter
        }
        let eyeCenter = centerOfEye(iris)
        let eyeRadius = headRadius / Constants.EyeRadius
        if eyesOpen {
            beizerPath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius - 7, startAngle: 0, endAngle: fullCircle * 2, clockwise: true)
        }else{
            beizerPath.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            beizerPath.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        beizerPath.lineWidth = lineWidth
        return beizerPath
    }
    private func nose() -> UIBezierPath {
        let height = circleCenter.y
        let width = circleCenter.x
        beizerPath = UIBezierPath()
        beizerPath.move(to: CGPoint(x: bounds.midX, y: bounds.midY))
        beizerPath.addLine(to: CGPoint(x: width + Constants.NoseOffSet, y: height + Constants.NoseOffSet))
        beizerPath.addLine(to: CGPoint(x: width - Constants.NoseOffSet, y: height + Constants.NoseOffSet))
        beizerPath.close()
        beizerPath.lineWidth = lineWidth
        return beizerPath
    }
    private func mouth() -> UIBezierPath {
        let width = headRadius / Constants.MouthWidth
        let height = headRadius / Constants.MouthHeight
        let offSet = headRadius / Constants.MouthOffSet
        let mouthLine = CGRect(x: circleCenter.x - width / 2, y: circleCenter.y + offSet, width: width, height: height)
        let startPoint =  CGPoint(x: mouthLine.minX, y: mouthLine.midY)
        let endPoint = CGPoint(x: mouthLine.maxX, y: mouthLine.midY)
        let smileOffSet = CGFloat(max(-1,min(MouthCurve, 1))) * mouthLine.height
        let cp1 = CGPoint(x: startPoint.x + mouthLine.width / 3, y: startPoint.y + smileOffSet)
        let cp2 = CGPoint(x: endPoint.x - mouthLine.width / 3, y: startPoint.y + smileOffSet)
        beizerPath.move(to: startPoint)
        beizerPath.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        beizerPath.lineWidth = lineWidth
        colorforMouth.set()
        return beizerPath
    }
    private func eyebrows(_ eyebrows: PersonFaceView.EyeBrows) -> UIBezierPath {
        func centerOfEye(_ eye: EyeBrows) -> CGPoint {
            let eyeOffSet = headRadius / Constants.EyeOffSet
            var eyeCenter = circleCenter
            eyeCenter.y -= eyeOffSet
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffSet
            return eyeCenter
        }
        let eyeCenter = centerOfEye(eyebrows)
        let eyeRadius = headRadius / Constants.EyeRadius
        beizerPath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius + 13, startAngle: 0, endAngle: fullCircle, clockwise: false)
        beizerPath.lineWidth = eyeLashWidth
        colorforEyeBrows.set()
        return beizerPath
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        roundHead().fill()
        eyebrows(.left).stroke()
        eyebrows(.right).stroke()
        eyes(.left).stroke()
        eyes(.right).stroke()
        eyesIris(.left).fill()
        eyesIris(.right).fill()
        nose().stroke()
        mouth().stroke()
    }
    func ZoomInOut(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1
        default:
            break
        }
    }
}
