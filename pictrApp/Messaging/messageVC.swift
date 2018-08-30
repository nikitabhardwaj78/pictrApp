//
//  messageVC.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 3/7/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import FirebaseDatabase
class messageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
   
    var userChatsHandle: DatabaseHandle = 0
    var userChatsRef: DatabaseReference?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 71
        
        tableView.tableFooterView = UIView()
        
        
        }
        
        
        // Do any additional setup after loading the view.
    
    
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatListcell") as! chatListcell
        
//        cell.titlelabel.text = chat.title
//        cell.lastmessageLabel.text = chat.lastMessage
        return cell
    }
    @IBAction func backHome(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
