//
//  postImage.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/10/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import Kingfisher
class postImage: UITableViewCell {

    
   
    @IBOutlet var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        postImageView.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 }

}
//extension UIImage {
//
//    func cropedToRatio(ratio: CGFloat) -> UIImage? {
//        let newImageWidth = size.height * ratio
//
//        let cropRect = CGRect(x: ((size.width - newImageWidth) / 2.0) * scale,
//                              y: 0.0,
//                              width: newImageWidth * scale,
//                              height: size.height * scale)
//
//        guard let cgImage = cgImage else {
//            return nil
//        }
//        guard let newCgImage = cgImage.cropping(to: cropRect) else {
//            return nil
//        }
//
//        return UIImage(cgImage: newCgImage, scale: scale, orientation: imageOrientation)
//    }
//}

