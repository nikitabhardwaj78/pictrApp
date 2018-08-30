//
//  friendDetail.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/24/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


var picArray = [UIImage]()
class friendDetail: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var selectedUser : String!
    var user : User!
    var posts = [Post]()
    var profileHandle: DatabaseHandle = 0
    var profileRef: DatabaseReference?
    var useruid : String!
    var array = [UIImage]()
    var userID : String!
    var array2 = [UIImage]()
    
    @IBOutlet var navigationbar: UINavigationBar!
    @IBOutlet var profilepicture: UIImageView!
    @IBOutlet var collectionVieew: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        array2.removeAll()
        let uid = useruid
        getUserImages(uid: uid!)
        getUserProfilePicture(uid: uid!)
       
       // array2.append(contentsOf: picArray)
        profilepicture.contentMode = .scaleToFill
        profilepicture.layer.cornerRadius = 0.5 * profilepicture.bounds.size.width
        profilepicture.clipsToBounds = true
        collectionVieew.delegate = self
        
    self.collectionVieew.reloadData()

    }
    func getUserProfilePicture(uid : String)
    {
        let text = selectedUser
        navigationbar.topItem?.title = text
      
        let ref = Database.database().reference()
        let newProfilepicRef = ref.child("ProfilePic").child(uid)
        newProfilepicRef.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            let userInfo = snapshot.value as! NSDictionary
            if(userInfo["profileimg_url"] != nil)
            {
                let profileUrl = userInfo["profileimg_url"] as! String
                let imageUrl_dict = ["profileimg_url" : profileUrl ]
                profileImage_dict = imageUrl_dict
                if !profileUrl .isEmpty
                {
                    
                    let storageRef = Storage.storage().reference(forURL: profileUrl)
                    
                    storageRef.downloadURL(completion: { (url, error ) in
                        do {
                            let data = try Data(contentsOf: url!)
                            let image = UIImage(data: data as Data)
                            self.profilepicture.image = image
                        } catch {
                            print("There was an error!")
                            return
                        }
                    })
                }
            }
            else{
                print("userProfilePicture not there")
            }
        })
    }
    func getUserImages(uid : String)
    {
        let ref = Database.database().reference()
        let images = ref.child("posts").child(uid)
        images.observeSingleEvent(of : .value, with: { (snapshot) in
            
            if !snapshot.exists() { return }
            if let userInf = snapshot.value as? [String : AnyObject] {
                for each in userInf as [String :  AnyObject]
                {
                    let autoID = each.0
                    images.child(autoID).observe(.value, with: { (snapshot) in
                        if let imageDict = snapshot.value as? [String: AnyObject]
                        {
                            picArray.removeAll()
                            let imageurl = imageDict["image_url"] as! String
                            let storageRef = Storage.storage().reference(forURL: imageurl)
                            storageRef.downloadURL(completion: { (url, error ) in
                                do {
                                    
                                    let data = try Data(contentsOf: url!)
                                    let image = UIImage(data: data as Data)
                                    picArray.append(image!)
                                    
                                    
                                } catch {
                                    print("There was an error!")
                                    return
                                }
                                
                            })
                            
                        }
                    })
                }
            }
        })
        array2.append(contentsOf: picArray)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.collectionVieew.reloadData()
        }
 }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerfriend", for: indexPath) as! FriendsDetailCell
     
        cell.imageView.image = array2[indexPath.row]
      
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "friendsheader", for: indexPath) as! friendsheader
        
        
        
        let text2 = userID
        let selectedUseruid = text2
        let ref = Database.database().reference()
        
        let userDeatails = ref.child("users").child(useruid!)
        userDeatails.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            let userInfo = snapshot.value as! NSDictionary
            
            let postcount = userInfo.value(forKey: "post_count")
            let followercount = userInfo.value(forKey: "follower_count")
            let followingcount = userInfo.value(forKey: "following_count")
            
            let postCount = self.array2.count
            headerView.postsCount_lbl.text = "\(String(describing: postCount))"
            
            let followerCount = followercount ?? 0
            headerView.followersCount_lbl.text = "\(String(describing: followerCount))"
            
            
            let followingCount = followingcount ?? 0
            headerView.followingCount_lbl.text = "\(String(describing: followingCount))"
        })
        
        return headerView
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension friendDetail: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
}
