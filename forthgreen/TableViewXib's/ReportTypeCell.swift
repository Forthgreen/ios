//
//  ReportTypeCell.swift
//  forthgreen
//
//  Created by MACBOOK on 06/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class ReportTypeCell: UITableViewCell {

    @IBOutlet weak var reportReasonView: UIView!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var reportReasonLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
