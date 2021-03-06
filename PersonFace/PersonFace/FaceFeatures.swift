//
//  FaceModel.swift
//  PersonFace
//
//  Created by Sifiso Mazibuko on 2017/09/06.
//  Copyright © 2017 Sifiso Mazibuko. All rights reserved.
//

import Foundation

struct FaceFeatures {
    
    let eyes: Eyes
    let mouth: Mouth
    let faceColor: FaceColor
    
    enum Eyes: Int {
        case open
        case closed
    }
    enum Mouth: Int {
        case smile
        case frown
        case neutral
    }
    enum FaceColor {
        case happy
        case angry
        case normal
    }
}
