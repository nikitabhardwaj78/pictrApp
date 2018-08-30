//
//  newChatViewController.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 5/15/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit

class newChatViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var nextButtonTapped: UIBarButtonItem!

    
    var following = [User]()
    var selectedUser: User?
   var existingChat: Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButtonTapped.isEnabled = true
        tableView.tableFooterView = UIView()
        
        UserService.following { [weak self] (following) in
            self?.following = following
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    
    @IBAction func nextBtnTApped(_ sender: UIButton) {
        guard let selectedUser = selectedUser else { return }
        
        // 2
        sender.isEnabled = false
        // 3
        ChatService.checkForExistingChat(with: selectedUser) { (chat) in
            // 4
            sender.isEnabled = true
            self.existingChat = chat
            
            self.performSegue(withIdentifier: "toChat", sender: self)
        }
    }
    
    
    @IBAction func BackBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
     /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension newChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewChatUserCell") as! newChatUserCellTableViewCell
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: newChatUserCellTableViewCell, at indexPath: IndexPath) {
        let follower = following[indexPath.row]
        cell.textLabel?.text = follower.username
        
        if let selectedUser = selectedUser, selectedUser.uid == follower.uid {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}
extension newChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        // 2
        selectedUser = following[indexPath.row]
        cell.accessoryType = .checkmark
        
        // 3
        nextButtonTapped.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 4
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        // 5
        cell.accessoryType = .none
    }
}
extension newChatViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "toChat", let destination = segue.destination as? ChatViewController, let selectedUser = selectedUser {
            let members = [selectedUser, User.current]
            destination.chat = existingChat ?? Chat(members: members)
        }
    }
}
