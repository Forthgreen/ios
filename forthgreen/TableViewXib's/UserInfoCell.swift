//
//  UserInfoCell.swift
//  forthgreen
//
//  Created by MACBOOK on 09/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {

    // OUTLETS
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var otherUserProfileBtn: UIButton!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
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
        followBtn.sainiCornerRadius(radius: 4)
        profileImage.sainiCornerRadius(radius: profileImage.frame.height / 2)
    }
    
}
