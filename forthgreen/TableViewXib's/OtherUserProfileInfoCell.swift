//
//  OtherUserProfileInfoCell.swift
//  forthgreen
//
//  Created by MACBOOK on 09/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit

class OtherUserProfileInfoCell: UITableViewCell {

    //OUTLETS
    @IBOutlet weak var heightConstraintOfFollowBtn: NSLayoutConstraint!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var followerFollowingBtn: UIButton!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var viewFollow: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - configUI
    private func configUI() {
        profileImage.sainiCornerRadius(radius: profileImage.frame.height / 2)
        followBtn.sainiCornerRadius(radius: 4)
    }
}
