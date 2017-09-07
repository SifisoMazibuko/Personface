//
//  ViewController.swift
//  PersonFace
//
//  Created by Sifiso Mazibuko on 2017/09/06.
//  Copyright © 2017 Sifiso Mazibuko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var faceView: PersonFaceView! {
        didSet{
            GestureRecognizers()
        }
    }

    private func GestureRecognizers() {
        faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(PersonFaceView.ZoomInOut(_:))))
        faceView.addGestureRecognizer(UITapGestureRecognizer(target: faceView, action: #selector(PersonFaceView.tapToOpenEyes(_:))))
    }

}

