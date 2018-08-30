//
//  imageAndSize.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/5/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    var aspectHeight: Float {
        let heightRatio = size.height / 736
        let widthRatio = size.width / 414
        let aspectRatio = fmax(heightRatio, widthRatio)
        
        return Float(size.height / aspectRatio)
    }
}
