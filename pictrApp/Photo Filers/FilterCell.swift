//
//  filterCell.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 5/2/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import UIKit

class FilterCell: UICollectionViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
