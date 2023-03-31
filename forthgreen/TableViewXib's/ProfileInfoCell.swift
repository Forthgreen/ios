//
//  ProfileInfoCell.swift
//  forthgreen
//
//  Created by MACBOOK on 08/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit

class ProfileInfoCell: UITableViewCell {

    //OUTLETS
    @IBOutlet weak var followerFollowingBtn: UIButton!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
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
    }
    
}
