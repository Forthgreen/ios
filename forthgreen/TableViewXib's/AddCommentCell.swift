//
//  AddCommentCell.swift
//  forthgreen
//
//  Created by MACBOOK on 10/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

class AddCommentCell: UITableViewCell {

    //OUTLETS
    @IBOutlet weak var loadMoreBtnOfReplies: UIButton!
    @IBOutlet weak var loadMoreViewOfReplies: UIView!
//    @IBOutlet weak var postBtn: UIButton!
//    @IBOutlet weak var commentTextfield: UITextField!
//    @IBOutlet weak var commentTxtView: sainiCardView!
    @IBOutlet weak var loadMoreBtn: UIButton!
    @IBOutlet weak var loadMoreBtnView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - configUI
//    private func configUI() {
//        commentTxtView.layer.borderColor = #colorLiteral(red: 0.7568627451, green: 0.7960784314, blue: 0.8117647059, alpha: 1)
//        commentTxtView.layer.borderWidth = 1
//    }
    
}
