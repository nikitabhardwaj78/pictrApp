//
//  Storage.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/5/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct StorageService
{
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // 1
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        // 2
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // 4
            completion(metadata?.downloadURL())
        })
    }
 
    
}
