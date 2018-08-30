//
//  profileHeaderView.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 3/23/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit

class profileHeaderView: UICollectionReusableView {
         
  
    @IBOutlet var postsCount_lbl: UILabel!
    @IBOutlet var followersCount_lbl: UILabel!
    @IBOutlet var followingCount_lbl: UILabel!

    override func awakeFromNib() {
 
        followersCount_lbl.isUserInteractionEnabled =  true
        followingCount_lbl.isUserInteractionEnabled = true
        
      
        
    }
    
   
}
