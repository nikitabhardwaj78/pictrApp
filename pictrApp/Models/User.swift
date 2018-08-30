//
//  User.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/5/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot
class User : NSObject {

    // MARK: - Properties
    var followerCount: Int?
    var followingCount: Int?
    var postCount: Int?
    
    
    let uid: String
    let username: String
    
   
    
    var isFollowed = false
    // MARK: - Init
 
        
        // MARK: - Class Methods
        
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String,
            let followerCount = dict["follower_count"] as? Int,
            let followingCount = dict["following_count"] as? Int,
            let postCount = dict["post_count"] as? Int 
          else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.postCount = postCount
        
      
        
        super.init()
    }

    init(uid : String , username : String ) {
        self.uid = uid
        self.username = username
        
       
        super.init()
        
    }
    private static var _current: User?
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        return currentUser
    }
    
    // MARK: - Class Methods
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
       
        if writeToUserDefaults {
     
          let data = NSKeyedArchiver.archivedData(withRootObject: user)
          UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String
       
           else { return nil }
        
        self.uid = uid
        self.username = username
       
        super.init()
    }
    }
extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
    }
   
}
