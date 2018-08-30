//
//  signUpVC.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 2/28/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

//let user: FIRUser? = Auth.auth().currentUser

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    var dict : [String : String]!
    let imagepicker = UIImagePickerController()
    var profilePic = UIImage()
    
    @IBOutlet var signupBtn: UIButton!
    @IBOutlet var profilePicture_view: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var chooseUsername: UITextField!
    @IBOutlet var confirmpassword: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        emailTextField.delegate = self
        password.delegate = self
        chooseUsername.delegate = self
        confirmpassword.delegate = self
        
        // TextField Placeholder properties.
        self.scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        password.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        chooseUsername.attributedPlaceholder = NSAttributedString(string: "User Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        confirmpassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
         emailTextField.textColor = UIColor.white
         password.textColor = UIColor.white
         chooseUsername.textColor = UIColor.white
         confirmpassword.textColor = UIColor.white
        
        emailTextField.returnKeyType = .next
        chooseUsername.returnKeyType = .next
        password.returnKeyType = .next
        confirmpassword.returnKeyType = .done
        
        // Profile Picture Properties
        profilePicture_view.contentMode = .scaleToFill
        profilePicture_view.layer.cornerRadius = 0.5 * profilePicture_view.bounds.size.width
        profilePicture_view.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profilePicture_view.addGestureRecognizer(tap)
        profilePicture_view.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(signUpVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signUpVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
   
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 105
                    //keyboardSize.height
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 105
                    //keyboardSize.height
            }
        }
    }
    
    // MARK: - profile Imageview Tapped
    @objc func imageTapped() {
        imagepicker.delegate = self
        imagepicker.sourceType = .photoLibrary
        present(imagepicker, animated: true, completion: nil)
        
    }
    
    // MARK: - Imagepicker Delegates
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profilePicture_view.image = pickedImage
        profilePic = profilePicture_view.image!
        profilePicture_view.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(_  textField: UITextField) -> Bool {
        
        if textField == chooseUsername {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            password.becomeFirstResponder()
        } else if textField == password {
            textField.resignFirstResponder()
            confirmpassword.becomeFirstResponder()
        }
        else if textField == confirmpassword
        {
            textField.resignFirstResponder()
        }
        
        return true

    }
    
    override func viewWillLayoutSubviews() {
        scrollView.contentSize =  CGSize(width: self.view.frame.size.width, height: 650)
    }
    
    func CheckAllFields()
    {
        
    }
    func userSignup()
    {
        if password.text == "" && emailTextField.text == "" && chooseUsername.text == "" && confirmpassword.text == ""
        {
            let alertController = UIAlertController(title: "Error", message: "Empty Fields", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else if emailTextField.text == ""
        {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else if chooseUsername.text == ""
        {
            let alertController = UIAlertController(title: "Error", message: "Please enter a username", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else if password.text != confirmpassword.text
        {
            let alertController = UIAlertController(title: "Error", message: "password did not match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
        else{
        if self.isValidEmail(email: self.emailTextField.text) && self.isValidPassword(testStr: self.password.text)
        {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: password.text!, completion: { (user, err) in
                
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
            })
            guard let firUser = Auth.auth().currentUser,
                let username = chooseUsername.text ,
                !username.isEmpty else
            { return }
            //       let profilepicture = profilePicture_view.image
            //            profilePictureService.create(for: profilePicture_view.image!)
            
            
            UserService.create(firUser, username: username) { (user) in
                guard let user = user else { return }
                User.setCurrent(user, writeToUserDefaults: true)
                
                print("Created new user: \(user.username)")
                
                let img : UIImage? = self.profilePicture_view.image
                if img != nil
                {
                    print("profile  picture choosen")
                    profilePictureService.createProfilepic(for: self.profilePicture_view.image!)
                    
                }
                else
                {
                    print("default Picture Set")
                    profilePictureService.createProfilepic(for: UIImage(named: "profile")!)
                }
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainView")
                self.present(vc!, animated: true, completion: nil)
                print("New User Sucessfully Created")
            }
        }
        
        else
        {
            
            let alertController = UIAlertController(title: "Error", message: "Invalid Email", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        }
    }
    
    
    // MARK: - Signup Button
    @IBAction func createAccount(_ sender: UIButton) {
        print("Signup Button Pressed")
        userSignup()
        print("Sucessfully Created  New User")
        
    }
   
    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    // MARK: - Facebook Login Button
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     
     */
    
    @IBAction func signUpcancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
