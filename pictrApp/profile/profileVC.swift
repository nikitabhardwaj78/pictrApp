//
//  profileVC.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 3/6/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

class profileVC: UIViewController {
    
    var currentUserId = Auth.auth().currentUser?.uid
    var uploadedImages_dict = [String: String]()
    var ref : DatabaseReference!
    var displayPicture = UIImage()
    var user: User!
    var posts = [Post]()
    var propict = [profilepicture]()
    var profileHandle: DatabaseHandle = 0
    var profileRef: DatabaseReference?
    var database: Database!
    var storage: Storage!
    var picArray = [UIImage]()
    let myUserID = Auth.auth().currentUser?.uid
     var authHandle: AuthStateDidChangeListenerHandle?
    @IBOutlet var navigationbar: UINavigationBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var profilepictureview: UIImageView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        profilepictureview.contentMode = .scaleToFill
        profilepictureview.layer.cornerRadius = 0.5 * profilepictureview.bounds.size.width
        profilepictureview.clipsToBounds = true
        
        user = user ?? User.current
        self.navigationbar.topItem?.title = User.current.username
        
        profileHandle = UserService.observeProfile(for: user) { [unowned self] (ref, user, posts) in
            self.profileRef = ref
            self.user = user
            self.posts = posts
            
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profilepictureview.addGestureRecognizer(tap)
        profilepictureview.isUserInteractionEnabled = true
        
        getuserProfilepic()
        
        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
            guard user == nil else { return }
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(viewController!, animated: true, completion: nil)
        }
        
        
        
        
        
        
  }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    deinit {
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
        profileRef?.removeObserver(withHandle: profileHandle)
    }
    // Do any additional setup after loading the view.
    
    
    
    
    
    
    
    @objc func imageTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailprofile") as? profileDetailVC
        present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    func getuserProfilepic()
    {
        
        
        let currentUser = User.current
        
        //        //MARK: - Gets profile picture from firebase.
        let ref = Database.database().reference()
        let newProfilepicRef = ref.child("ProfilePic").child(currentUser.uid)
        
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
                            self.profilepictureview.image = image
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
    override func viewWillAppear(_ animated: Bool) {
      
   getuserProfilepic()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
  
    @IBAction func logOutButtonTapped(_ sender: Any) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        {
            
            do {
                try Auth.auth().signOut()
            }
            catch let signOutError as NSError {
                
                print ("Error signing out: %@", signOutError)
            }
            
            print("\nLogout: UID is \(self.myUserID!)")
            
            
            //            UIApplication.shared.keyWindow?.rootViewController = viewController
            //            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            //            UserDefaults.standard.synchronize()
            
            //  self.dismiss(animated: true, completion: nil)
            
        }
    }
    @IBAction func findfriendsbtn(_ sender: Any) {
        print("findfriends button tapped")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "findfriends")
        present(vc!, animated: true, completion: nil)
    }
}
extension profileVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadedPosts", for: indexPath) as! uploadedPostsCollectionCell
        let post = posts[indexPath.row]
        
        let imageURL = URL(string: post.imageURL)
        cell.userPosts.kf.setImage(with: imageURL) 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! profileHeaderView
        
//        let postCount = user.postCount ?? 0
//        headerView.postsCount_lbl.text = "\(String(describing: postCount))"
        
        let postCount = posts.count 
        headerView.postsCount_lbl.text = "\(String(describing: postCount))"
        let followerCount = user.followerCount ?? 0
        headerView.followersCount_lbl.text = "\(String(describing: followerCount))"
        
        
        let followingCount = user.followingCount ?? 0
        headerView.followingCount_lbl.text = "\(String(describing: followingCount))"
        
     
        return headerView
    }
}
extension profileVC: UICollectionViewDelegateFlowLayout {
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
