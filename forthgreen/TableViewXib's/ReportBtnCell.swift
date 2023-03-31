//
//  ReportBtnCell.swift
//  forthgreen
//
//  Created by MACBOOK on 06/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class ReportBtnCell: UITableViewCell {

    @IBOutlet weak var reportBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ConfigUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        reportBtn.layer.cornerRadius = 5
    }
    
}
