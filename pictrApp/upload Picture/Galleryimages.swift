//
//  Galleryimages.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/23/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit

class Galleryimages: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            photoImageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}
