//
//  postHeaderCell.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/10/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit

class postHeaderCell: UITableViewCell {

   
    
    @IBOutlet var header_imageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var LocationLAbel: UILabel!
    static let height: CGFloat = 54
    override func awakeFromNib() {
        super.awakeFromNib()
        header_imageView.contentMode = .scaleToFill
        header_imageView.layer.cornerRadius = 0.5 * header_imageView.bounds.size.width
        header_imageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
