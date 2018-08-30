//
//  ViewController.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 2/27/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseAuthUI


typealias FIRUser = FirebaseAuth.User

class ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet var vview: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet weak var txt_login: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var loginBtnPressed: UIButton!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        
        // MARK : - Texfield Delegates.
        scrollView.delegate = self
        self.txt_login.delegate = self
        self.txt_password.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //MARK: - Textfield placeholder Properties.
        txt_login.attributedPlaceholder = NSAttributedString(string: "User Name",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txt_password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txt_login.textColor = UIColor.white
        txt_password.textColor = UIColor.white
        
        txt_login.returnKeyType = .next
        txt_password.returnKeyType = .done
        
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
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 80
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 80
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_login {
            textField.resignFirstResponder()
            txt_password.becomeFirstResponder()
        } else if textField == txt_password {
            textField.resignFirstResponder()
        }
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            print(auth)
            if let user = user {
                print(user)
            }
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 647)
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if self.txt_login.text == "" || self.txt_password.text == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.txt_login.text!, password: self.txt_password.text!) { (user, error) in
                
                if error == nil {
                    if let user = Auth.auth().currentUser
                    {
                        let rootRef = Database.database().reference()
                        let userRef = rootRef.child("users").child(user.uid)
                        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                            
                            if let user = User(snapshot: snapshot) {
                                User.setCurrent(user, writeToUserDefaults: true)
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainView")
                                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                                UserDefaults.standard.synchronize()
                                self.present(vc!, animated: true, completion: nil)
                                
                            }
                            UserService.show(forUID: user.uid, completion: { (user) in
                                if let user = user {
                                    // handle existing user
                                    User.setCurrent(user, writeToUserDefaults: true)
                                }
                            })
                        })
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainView")
                        
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        self.present(vc!, animated: true, completion: nil)
                    }
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        }
   }
}






