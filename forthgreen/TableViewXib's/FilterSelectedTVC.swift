//
//  FilterSelectedTVC.swift
//  forthgreen
//
//  Created by iMac on 7/23/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit

class FilterSelectedTVC: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var filterLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
