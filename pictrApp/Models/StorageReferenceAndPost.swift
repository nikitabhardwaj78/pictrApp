//
//  StorageReferenceAndPost.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/5/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

@available(iOS 10.0, *)
extension StorageReference {
    @available(iOS 10.0, *)
    static let dateFormatter = DateFormatter()
    
    static func newPostImageReference() -> StorageReference {
        let uid = Auth.auth().currentUser?.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(String(describing: uid))/\(timestamp).jpg")
    }
}
