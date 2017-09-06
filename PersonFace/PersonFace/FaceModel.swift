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
    let nose: Nose
    let mouth: Mouth
    
    enum Eyes {
        case open
        case closed
    }
    enum Nose {
        
    }
    enum Mouth {
        case smile
        case frown
    }
}
