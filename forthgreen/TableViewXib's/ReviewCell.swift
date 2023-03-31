//
//  ReviewCell.swift
//  forthgreen
//
//  Created by MACBOOK on 06/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    // OUTLETS
    @IBOutlet weak var gotoProfileBtn: UIButton!
    @IBOutlet weak var reviewTitleLbl: UILabel!
    @IBOutlet weak var reviewTextLbl: UILabel!
    @IBOutlet weak var star5Image: UIImageView!
    @IBOutlet weak var star4Image: UIImageView!
    @IBOutlet weak var star3Image: UIImageView!
    @IBOutlet weak var star2Image: UIImageView!
    @IBOutlet weak var star1Image: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileProductImage: UIImageView!
    @IBOutlet weak var threeDotsBtn: UIButton!
    @IBOutlet weak var ProfileImage: UIView!
    @IBOutlet weak var profileBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - renderProfileImage
    func renderProfileImage(circle:Bool){
        if circle{
            ProfileImage.layer.cornerRadius = ProfileImage.frame.height / 2
            profileProductImage.layer.cornerRadius = profileProductImage.frame.height / 2
        }
        else{
            ProfileImage.layer.cornerRadius = 0
            profileProductImage.layer.cornerRadius = 0
        }
    }
    
    //MARK: - renderRatingStar
    func renderRatingStar(count: Int){
        switch count{
        case 0:
            star1Image.image = UIImage(named: "star_white")
            star2Image.image = UIImage(named: "star_white")
            star3Image.image = UIImage(named: "star_white")
            star4Image.image = UIImage(named: "star_white")
            star5Image.image = UIImage(named: "star_white")
            break
        case 1:
            star1Image.image = UIImage(named: "star_black")
            star2Image.image = UIImage(named: "star_white")
            star3Image.image = UIImage(named: "star_white")
            star4Image.image = UIImage(named: "star_white")
            star5Image.image = UIImage(named: "star_white")
            break
        case 2:
            star1Image.image = UIImage(named: "star_black")
            star2Image.image = UIImage(named: "star_black")
            star3Image.image = UIImage(named: "star_white")
            star4Image.image = UIImage(named: "star_white")
            star5Image.image = UIImage(named: "star_white")
            break
        case 3:
            star1Image.image = UIImage(named: "star_black")
            star2Image.image = UIImage(named: "star_black")
            star3Image.image = UIImage(named: "star_black")
            star4Image.image = UIImage(named: "star_white")
            star5Image.image = UIImage(named: "star_white")
            break
        case 4:
            star1Image.image = UIImage(named: "star_black")
            star2Image.image = UIImage(named: "star_black")
            star3Image.image = UIImage(named: "star_black")
            star4Image.image = UIImage(named: "star_black")
            star5Image.image = UIImage(named: "star_white")
            break
        case 5:
            star1Image.image = UIImage(named: "star_black")
            star2Image.image = UIImage(named: "star_black")
            star3Image.image = UIImage(named: "star_black")
            star4Image.image = UIImage(named: "star_black")
            star5Image.image = UIImage(named: "star_black")
            break
        default:
            break
        }
    }
    
}
