//
//  settingsVC.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 3/6/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class settingsVC: UIViewController {
    var dbRef: DatabaseReference!
     var authHandle: AuthStateDidChangeListenerHandle?
    let myUserID = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dbRef = Database.database().reference()
        
        
        
        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
            guard user == nil else { return }
            
          let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(viewController!, animated: true, completion: nil)
        }
    }
    
    deinit {
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func logOut(_ sender: Any) {
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
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        // let vc = self.storyboard?.instantiateViewController(withIdentifier: "profile")
        
        // present(vc!, animated: true, completion: nil)
    }
}
