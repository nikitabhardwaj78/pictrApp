//
//  PostService.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/5/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


struct PostService {
    
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            
           create(forURLString: urlString, aspectHeight: CGFloat(aspectHeight))
            
        }
       
        
        
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat ) {
        let currentUser = User.current
        
       // let post = Post(imageURL: urlString , imageHeight: Float(aspectHeight), location: location, caption: caption)
           let post = Post(imageURL: urlString, imageHeight: Float(aspectHeight)) 
        
        
        // 1
        let rootRef = Database.database().reference()
        let newPostRef = rootRef.child("posts").child(currentUser.uid).childByAutoId()
        let newPostKey = newPostRef.key
        
        // 2
        UserService.followers(for: currentUser) { (followerUIDs) in
            // 3
            let timelinePostDict = ["poster_uid" : currentUser.uid]
            
            // 4
            var updatedData: [String : Any] = ["timeline/\(currentUser.uid)/\(newPostKey)" : timelinePostDict]
            
            // 5
            for uid in followerUIDs {
                updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
            }
            
            // 6
            let postDict = post.dictValue
            updatedData["posts/\(currentUser.uid)/\(newPostKey)"] = postDict
            
            // 7
            rootRef.updateChildValues(updatedData, withCompletionBlock: { (error, ref) in
                let postCountRef = Database.database().reference().child("users").child(currentUser.uid).child("post_count")
                
                postCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                    let currentCount = mutableData.value as? Int ?? 0
                    
                    mutableData.value = currentCount + 1
                    
                    return TransactionResult.success(withValue: mutableData)
                })
            })
        }
}
   
    static func show(forKey postKey: String, posterUID: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("posts").child(posterUID).child(postKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
            
            LikeService.isPostLiked(post) { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            }
        })
    }
}
