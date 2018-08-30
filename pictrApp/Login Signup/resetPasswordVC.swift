//
//  resetPasswordVC.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 2/28/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class resetPasswordVC: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var txt_email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_email.attributedPlaceholder = NSAttributedString(string: "Email",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txt_email.textColor = UIColor.white
        txt_email.delegate = self
        
        txt_email.returnKeyType = .default
        // Do any additio√nal setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_email{
            textField.resignFirstResponder()
        }
        
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   @IBAction func forgotPassword(_ sender: Any) {
        
        if self.txt_email.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            Auth.auth().sendPasswordReset(withEmail: txt_email.text!, completion: { (error) in
                var title = ""
                var message = ""
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.txt_email.text = ""
                }
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
   
    @IBAction func cancelButtonpressed(_ sender: Any) {
        
       dismiss(animated: true, completion: nil)
        
    }
}
