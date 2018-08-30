//
//  searchCollectionCell.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 3/7/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit

class searchCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    override func
        
        
        awakeFromNib() {
        cellView.layer.cornerRadius = 6
        cellView.layer.masksToBounds = true
    }
    
    
    
}
