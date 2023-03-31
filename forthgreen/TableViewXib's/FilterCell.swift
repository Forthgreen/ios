//
//  FilterCell.swift
//  forthgreen
//
//  Created by MACBOOK on 06/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var leadingConstraintOfStackView: NSLayoutConstraint!
    @IBOutlet weak var filterImage: UIImageView!
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
