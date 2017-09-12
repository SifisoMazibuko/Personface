//
//  FaceEmotionsViewController.swift
//  PersonFace
//
//  Created by Sifiso Mazibuko on 2017/09/08.
//  Copyright © 2017 Sifiso Mazibuko. All rights reserved.
//

import UIKit

class FaceEmotionsViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
            if let faceViewController = destinationViewController as? ViewController {
                if let identifier = segue.identifier {
                    if let expressions = faceEmotions[identifier] {
                        faceViewController.expression = expressions
                        faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
                    }
                }
            }
        }
    }
    private let faceEmotions: [String: FaceFeatures] = [
        "smile" : FaceFeatures(eyes: .open, mouth: .smile, faceColor: .happy),
        "frown" : FaceFeatures(eyes: .open, mouth: .frown, faceColor: .angry ),
        "neutral" : FaceFeatures(eyes: .closed, mouth: .neutral, faceColor: .normal)
    ]
}
