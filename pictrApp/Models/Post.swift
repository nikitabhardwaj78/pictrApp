//
//  Post.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/5/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import FirebaseAuth

class Post {
    var isLiked = false
    var likeCount : Int
    let poster : User       //poster property will store a reference to the user that owns the post.
    var key: String?
   
    let imageURL: String
    let imageHeight: Float
    let creationDate: Date
  
    
    var dictValue: [String : Any]
    {
        
        let createdAgo = Date.timeIntervalBetween1970AndReferenceDate
        let userDict = ["uid" : poster.uid,
                        "username" : poster.username
            ]
        
        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "created_at" : createdAgo,
                "like_count" : likeCount,
                "poster" : userDict
               
            ]
        
        
    }
    init(imageURL: String, imageHeight: Float) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
        self.likeCount = 0
        self.poster = User.current
       
       
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let imageURL = dict["image_url"] as? String,
            let imageHeight = dict["image_height"] as? Float ,
            let createdAgo = dict["created_at"] as? TimeInterval,
            let likeCount = dict["like_count"] as? Int,
            let userDict = dict["poster"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String
             else { return nil }
        self.likeCount = likeCount
        self.poster = User(uid: uid, username: username)
        self.key = snapshot.key
        self.imageURL = imageURL
        self.imageHeight = Float(imageHeight)
        self.creationDate = Date(timeIntervalSinceReferenceDate: createdAgo)
            //Date(timeIntervalSince1970: createdAgo)
        
        
    }
   
}
