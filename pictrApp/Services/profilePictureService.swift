//
//  profilePictureService.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/27/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

struct profilePictureService {
    
    static func createProfilepic(for image: UIImage){
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
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        let currentUser = User.current
        
        let profilePicture = profilepicture(profileimageURL: urlString, imageHeight: Float(aspectHeight))

        let rootRef = Database.database().reference()

        let newProfilepicRef = rootRef.child("ProfilePic").child(currentUser.uid).childByAutoId()
        let newProfilepicKey = newProfilepicRef.key
        UserService.followers(for: currentUser) { (followerUIDs) in

            let timelinePostDict = ["poster_uid" : currentUser.uid]
            var updatedData: [String : Any] = ["timeline/\(currentUser.uid)/\(newProfilepicKey)" : timelinePostDict]

            for uid in followerUIDs {
                updatedData["timeline/\(uid)/\(newProfilepicKey)"] = timelinePostDict
            }
            let postDict = profilePicture.dictValue

            updatedData["ProfilePic/\(currentUser.uid)"] = postDict
            
            rootRef.updateChildValues(updatedData)

    }
        
        
    }
    static func show(forKey postKey: String, posterUID: String, completion: @escaping (profilepicture?) -> Void) {
            let ref = Database.database().reference().child("ProfilePic").child(posterUID).child(postKey)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard profilepicture(snapshot: snapshot) != nil else {
                    return completion(nil)
                }

            })
        }
    
}
