//
//  propic.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/30/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot
class propic :  NSObject
{
    let uid: String
    let username: String
    let profilePicture : String
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String,
           let profilePicture = dict["profileimg_url"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        self.profilePicture = profilePicture
        
        
        
        super.init()
    }
    init(uid : String , username : String , profilepicture : String) {
        self.uid = uid
        self.username = username
        self.profilePicture = profilepicture
        
        super.init()
        
    }
 
    // MARK: - Class Methods
   
}
