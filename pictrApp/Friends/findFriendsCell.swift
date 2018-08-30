//
//  findFriendsCell.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/10/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
protocol findFriendsCellDelegate: class {
    func didTapFollowButton(_ followButton: UIButton, on cell: findFriendsCell)
}
class findFriendsCell: UITableViewCell {
    weak var delegate : findFriendsCellDelegate?
    @IBOutlet var followButton: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var uidLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 0
        followButton.layer.cornerRadius = 6
        followButton.clipsToBounds = true
      
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func followButtonTapped(_ sender: UIButton) {
        print("Follow Button tapped ")
        delegate?.didTapFollowButton(sender, on: self)
    }
}
