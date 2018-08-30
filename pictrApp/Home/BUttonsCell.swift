//
//  BUttonsCell.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/10/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
protocol BUttonsCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: BUttonsCell)
     func didTapCommentButton(_ commentButton : UIButton , on cell : BUttonsCell)
}
class BUttonsCell: UITableViewCell {
 weak var delegate: BUttonsCellDelegate?
    
    @IBOutlet var time: UILabel!
    @IBOutlet var likeCount_lbl: UILabel!
    @IBOutlet var msgBtn: UIButton!
    @IBOutlet var commentBtn: UIButton!
    @IBOutlet var likeBtn: UIButton!
    
    static let height: CGFloat = 46
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myButtonTapped()
       // likeBtn.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        //likeBtn.setImage(UIImage(named: "black_like")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
    }
    func myButtonTapped(){
        if likeBtn.isSelected == true {
            likeBtn.isSelected = false
            likeBtn.setImage(UIImage(named : "like"), for: UIControlState.normal)
        }else {
            likeBtn.isSelected = true
            likeBtn.setImage(UIImage(named : "like"), for: UIControlState.selected)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    
    @IBAction func onMsgClick(_ sender: UIButton) {
    }
    @IBAction func onCommentclick(_ sender: UIButton) {
        delegate?.didTapCommentButton(sender, on: self)
    }
    @IBAction func onLikeClick(_ sender: UIButton) {
       
         delegate?.didTapLikeButton(sender, on: self)
    }
}
