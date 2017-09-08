//
//  ViewController.swift
//  PersonFace
//
//  Created by Sifiso Mazibuko on 2017/09/06.
//  Copyright © 2017 Sifiso Mazibuko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var expression = FaceFeatures(eyes: .open, mouth: .frown) { didSet{ updateExpession() }}
    @IBOutlet weak var faceView: PersonFaceView! {
        didSet{
            GestureRecognizers()
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
            expression = FaceFeatures(eyes: eyes, mouth: expression.mouth)
        default:
            break
        }
    }
    
    private func GestureRecognizers() {
        faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(PersonFaceView.ZoomInOut(_:))))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToCloseEyes(_:)))
        tap.numberOfTapsRequired = 1
        faceView.addGestureRecognizer(tap)
    }
    
    private func updateExpession(){
        switch expression.eyes {
        case .open:
            faceView.eyesOpen = true
        case .closed:
            faceView.eyesOpen = false
        }
        faceView.MouthCurve = mouthCurves[expression.mouth] ?? 0.0
    }
    private let mouthCurves = [
        FaceFeatures.Mouth.smile: 1.0,
        FaceFeatures.Mouth.frown: -1.0
    ]

}

