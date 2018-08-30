//
//  FindfriendsVc.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/10/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class FindfriendsVc: UIViewController
{
    
    //MARK: - Subviews
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchbar: UISearchBar!
    // MARK: - Properties
    
    
    
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var users = [User]()
    var searchActive : Bool = false
    var filteredUsers = [User]()
    var uidd : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
        
        self.searchController = ({
            
            searchController.searchBar.delegate = self
            searchController.searchBar.barTintColor = UIColor.white
            
            searchController.searchBar.showsCancelButton = true
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search Users"
            if #available(iOS 11.0, *) {
                navigationItem.searchController = searchController
            } else {
                // Fallback on earlier versions
            }
            definesPresentationContext = true
            tableView.tableHeaderView = searchController.searchBar
            return searchController
        })()
        tableView.reloadData()
        
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText : String, scope : String = "All"){
        filteredUsers = users.filter({ (user : User) -> Bool in
            let doesNameMatch = (scope == "All") || ( user.username == scope)
            if searchBarIsEmpty(){
                return doesNameMatch
            }else
            {
                return doesNameMatch && user.username.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.users = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailfriends"{
            if let indexPath = tableView!.indexPathForSelectedRow as NSIndexPath?{
                let selectedCell = tableView?.cellForRow(at: indexPath as IndexPath) as? findFriendsCell
                let userName = selectedCell?.usernameLabel.text
                let userUID = selectedCell?.uidLabel.text
                uidd = userUID!
                let vc = segue.destination as! friendDetail
                vc.selectedUser = userName
                vc.useruid = uidd
              
               
        }
    }
    }
    
    @IBAction func bsckToprofile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension FindfriendsVc: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredUsers.count
        }
        
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFriendsCell") as! findFriendsCell
        let user : User
        if isFiltering()
        {
            user = filteredUsers[indexPath.row]
        }
        else
        {
            configure(cell: cell, atIndexPath: indexPath)
            cell.delegate = self
            configure(cell: cell, atIndexPath: indexPath)
        }
        
        
        
        
        return cell
        
    }
    func configure(cell: findFriendsCell, atIndexPath indexPath: IndexPath) {
        let user = users[indexPath.row]
        cell.usernameLabel.text = user.username
        cell.uidLabel.text = user.uid
        
        cell.followButton.isSelected = user.isFollowed
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension FindfriendsVc: findFriendsCellDelegate {
    func didTapFollowButton(_ followButton: UIButton, on cell: findFriendsCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        followButton.isUserInteractionEnabled = false
        let followee = users[indexPath.row]
        
        FollowService.setIsFollowing(!followee.isFollowed, fromCurrentUserTo: followee) { (success) in
            defer {
                followButton.isUserInteractionEnabled = true
            }
            guard success else { return }
            followee.isFollowed = !followee.isFollowed
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}


extension FindfriendsVc: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        let searchBar = searchController.searchBar
        //  let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text! )
    }
}
extension FindfriendsVc: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancelButtonClicked")
        searchController.searchBar.text = " "
        searchController.searchBar.showsCancelButton = false
        searchController.resignFirstResponder()
    }
    
}
