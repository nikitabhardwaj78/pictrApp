//
//  profileDetailVC.swift
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

var profileImage_dict = [String : String]()

class profileDetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var currentUserId = Auth.auth().currentUser?.uid

    
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailAddressTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet weak var detailprofileImage: UIImageView!
    var profilePicture = UIImage()
    let imagepicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = User.current.username
        detailprofileImage.contentMode = .scaleToFill
        detailprofileImage.layer.cornerRadius = 0.5 * detailprofileImage.bounds.size.width
        detailprofileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(profileImage_dict["profileimg_url"] != nil)
        {
            let storageRef = Storage.storage().reference(forURL: profileImage_dict["profileimg_url"]!)
            storageRef.downloadURL(completion: { (url, error ) in
                do {
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data as Data)
                    self.detailprofileImage.image = image
                } catch {
                    print("There was an error!")
                    return
                }
            })
        }
        let currentUser = User.current
        let rootRef = Database.database().reference()
        let userDeatil = rootRef.child("UserDeatils").child(currentUser.uid)
        userDeatil.observe(.value) { (snapshot) in
         if !snapshot.exists() { return }
         let userInfo = snapshot.value as! NSDictionary
            let name = userInfo["Name"] as! String
            let username = userInfo["username"] as! String
            let EmailAdress = userInfo["Email"] as! String
             let phoneNumber = userInfo["PhoneNumber"] as! String
            self.usernameTextField.text = username
            self.emailAddressTextField.text = EmailAdress
            self.nameTextField.text = name
            self.phoneNumberTextField.text = phoneNumber
            
        }
        
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeprofilePicture(_ sender: Any) {
        
        imagepicker.delegate = self
        imagepicker.sourceType = .photoLibrary
        present(imagepicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.detailprofileImage.image = pickedImage
        detailprofileImage.contentMode = .scaleAspectFit
        
        upLoadProfilepicture() { url in
            if url != nil {
              print("Url Present")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func upLoadProfilepicture(completion: @escaping (_ url: String?) -> Void) {
        
        profilePicture = detailprofileImage.image!
        profilePictureService.createProfilepic(for: profilePicture)
       

    }
    
    @IBAction func saveDeatiLs(_ sender: Any) {
        let uid = User.current.uid
        let name = nameTextField.text!
        let username = usernameTextField.text!
        let PhoneNumber = phoneNumberTextField.text!
        let Email = emailAddressTextField.text!
        
        let currentUser = User.current
        let rootRef = Database.database().reference()
        
        let userDeatil = rootRef.child("UserDeatils").child(currentUser.uid)
        let userDeatil_dict : [String : Any ] = ["uid" : uid ,
                                                 "Name" : name,
                               "username" : username ,
                               "PhoneNumber" : PhoneNumber,
                               "Email" : Email
                               ]
      
        userDeatil.updateChildValues(userDeatil_dict)
        
      dismiss(animated: true, completion: nil)
    }
    @IBAction func saveChanges(_ sender: Any) {
        _ = presentingViewController as? profileVC
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
