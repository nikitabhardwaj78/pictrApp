//
//  HomeVc.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 3/5/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Kingfisher
import UserNotifications
class HomeVc: UIViewController ,UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var dbRef : DatabaseReference!
    var postedImage = UIImage()
    let ref = Database.database().reference()
    var posts = [Post]()
    
    var profileImage = UIImage()
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
    let notificationContent = UNMutableNotificationContent()
        notificationContent.title  = "Welcome"
        notificationContent.body = "Welcome to pictr App"
        notificationContent.badge = 1
        notificationContent.categoryIdentifier = "PictrAppHome"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let reqidentifier = "pictrApp"
        let Req = UNNotificationRequest(identifier: reqidentifier, content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(Req) { (error) in
            print(error as Any)
        }
        configureTableView()
        reloadTimeline()
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    @objc func reloadTimeline() {
        UserService.timeline { (posts) in
            self.posts = posts
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            self.tableView.reloadData()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        
                switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "postHeaderCell") as! postHeaderCell
         

            cell.usernameLabel.text = post.poster.username
            //DispatchQueue.main.async {
            self.ref.child("ProfilePic").child(post.poster.uid).observeSingleEvent(of: .value, with: { snapshot in
                if !snapshot.exists() { return }
                let userInfo = snapshot.value as! NSDictionary
                let profileUrl = userInfo["profileimg_url"] as! String
                let storageRef = Storage.storage().reference(forURL: profileUrl)
                storageRef.downloadURL(completion: { (url, error ) in
                    do {
                        let data = try Data(contentsOf: url!)
                        let image = UIImage(data: data as Data)
                        cell.header_imageView.image = image
                    } catch {
                        print("There was an error!")
                        return
                    }
                })
//                let imageURL = URL(string: profileUrl)
//                cell.header_imageView.kf.setImage(with: imageURL)
            })
           
        return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "postImageCell") as! postImage
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonsCell") as! BUttonsCell
            cell.delegate = self
            configureCell(cell, with: post)
            return cell
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    func configureCell(_ cell: BUttonsCell, with post: Post) {
        cell.time.text = timestampFormatter.string(from: post.creationDate)
        cell.likeBtn.isSelected = post.isLiked
        cell.likeCount_lbl.text = "\(post.likeCount) likes"
        //add pull to refresh
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return postHeaderCell.height
            
        case 1:
            let post = posts[indexPath.section]
            return CGFloat(post.imageHeight)
            
        case 2:
            return BUttonsCell.height
            
        default:
            fatalError()
        }
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    override func viewWillAppear(_ animated: Bool) {
       // tableView.reloadData()
//        configureTableView()
//        reloadTimeline()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension HomeVc: BUttonsCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: BUttonsCell) { 
        print("did tap like button.....")
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title  = "Liked Your Photo"
        notificationContent.body = "\(User.current.username) liked your Picture"
        notificationContent.badge = 1
        notificationContent.categoryIdentifier = "PictrAppHome"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let reqidentifier = "pictrApp"
        let Req = UNNotificationRequest(identifier: reqidentifier, content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(Req) { (error) in
            print(error as Any)
        }
        
        
        
    guard let indexPath = tableView.indexPath(for: cell)
            else { return }
      likeButton.isUserInteractionEnabled = false
        let post = posts[indexPath.section]
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            defer {
                likeButton.isUserInteractionEnabled = true
            }
            guard success else { return }
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            guard let cell = self.tableView.cellForRow(at: indexPath) as? BUttonsCell
                else { return }
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }
    
    func didTapCommentButton(_ commentButton : UIButton , on cell : BUttonsCell)
    {
        print("Comment Button tapped")
        
        
    }
    
    
    
    
}

