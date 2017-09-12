//
//  ViewController.swift
//  PersonFace
//
//  Created by Sifiso Mazibuko on 2017/09/06.
//  Copyright © 2017 Sifiso Mazibuko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var expression = FaceFeatures(eyes: .closed, mouth: .neutral, faceColor: .happy) { didSet{ updateExpession() }}
    var blinkingEyes = false { didSet { blinkEyesIfNeeded() }}
    @IBOutlet weak var faceView: PersonFaceView! {
        didSet{
            gestureRecognizers()
            updateExpession()
        }
    }
    
    func tapToCloseEyes(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            var eyes: FaceFeatures.Eyes = expression.eyes
            if eyes == .closed {
                eyes = .open
            }else{
                eyes = .closed
            }
            expression = FaceFeatures(eyes: eyes, mouth: expression.mouth, faceColor: expression.faceColor)
        default:
            break
        }
    }
    
    private func gestureRecognizers() {
        faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(PersonFaceView.ZoomInOut(_:))))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToCloseEyes(_:)))
        tap.numberOfTapsRequired = 1
        faceView.addGestureRecognizer(tap)
    }
    
    private func updateExpession(){
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        }
        faceView?.MouthCurve = mouthCurves[expression.mouth] ?? 0.0
        faceView?.colorforHead = faceColors[expression.faceColor] ?? UIColor.red
    }
    private let mouthCurves = [
        FaceFeatures.Mouth.smile: 1.0,
        FaceFeatures.Mouth.frown: -1.0,
        FaceFeatures.Mouth.neutral: 0.0
    ]
    private let faceColors = [
        FaceFeatures.FaceColor.happy: UIColor.yellow,
        FaceFeatures.FaceColor.angry: UIColor.red,
        FaceFeatures.FaceColor.normal: UIColor.orange
    ]
    private struct blinkTimeDuration {
        static let closedDuration: TimeInterval = 0.5
        static let openDuration: TimeInterval = 3.5
    }
    private func blinkEyesIfNeeded(){
        if blinkingEyes {
            faceView.eyesOpen = false
            Timer.scheduledTimer(withTimeInterval: blinkTimeDuration.closedDuration, repeats: false, block: { (timer) in
                self.faceView.eyesOpen = true
                Timer.scheduledTimer(withTimeInterval: blinkTimeDuration.openDuration, repeats: false, block: { (timer) in
                    self.blinkEyesIfNeeded()
                })
            })
        }
    }
    private struct HeadShake {
        static let duration: TimeInterval = 0.3
        static let angle = CGFloat.pi / 4
    }
    private func rotate(_ angle: CGFloat) {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    private func rotateHead() {
        UIView.animate(withDuration: HeadShake.duration, animations: {
            self.rotate(HeadShake.angle)}, completion: { finished in
            if finished {
                UIView.animate(withDuration: HeadShake.duration, animations: { self.rotate(-HeadShake.angle * 2)}, completion: { finished in
                    UIView.animate(withDuration: HeadShake.duration, animations: {
                        self.rotate(HeadShake.angle)
                    })
                })
            }
        })
    }
    @IBAction func rotateHead(_ sender: UISwipeGestureRecognizer) {
        rotateHead()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blinkingEyes = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blinkingEyes = false
    }
}

