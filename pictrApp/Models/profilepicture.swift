//
//  profilepicture.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/27/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import FirebaseAuth

class profilepicture {
    var Picposter : propic?
    var key: String?
    let profileimgURL: String
    
    var dictValue: [String : Any]
    {
        
       
        let userDict = ["uid" : Picposter?.uid,
                        "username" : Picposter?.username,
                        "profileimg_url" : Picposter?.profilePicture]
        
        return ["profileimg_url": profileimgURL,
                 "poster" : userDict ]
        
        
    }
    init(profileimageURL: String, imageHeight: Float) {
        self.profileimgURL = profileimageURL
      
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            
            let userDict = dict["poster"] as? [String : Any],
            let profileimguRL = userDict["profileimg_url"] as? String,
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String
           
            else { return nil }
       
        self.Picposter = propic(uid: uid, username: username, profilepicture: profileimguRL)
        self.key = snapshot.key
        self.profileimgURL = profileimguRL
       
      
        
    }
    
}
