//
//  ProductDetailCell.swift
//  forthgreen
//
//  Created by MACBOOK on 05/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProductDetailCell: UITableViewCell {
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var brandImageView: RoundedView!
    @IBOutlet weak var productSmallImageView: UIImageView!
    @IBOutlet weak var productImages: ImageSlideshow!
    @IBOutlet weak var star5Image: UIImageView!
    @IBOutlet weak var star4Image: UIImageView!
    @IBOutlet weak var star3Image: UIImageView!
    @IBOutlet weak var star2Image: UIImageView!
    @IBOutlet weak var star1Image: UIImageView!
    @IBOutlet weak var starCountLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var brandNameLbl: UILabel!
    @IBOutlet weak var websiteBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    
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
        reviewBtn.layer.cornerRadius = 4
        websiteBtn.layer.cornerRadius = 4
        saveBtn.layer.cornerRadius = 4
        productSmallImageView.layer.borderWidth = 1
        productSmallImageView.layer.borderColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
        brandImageView.layer.borderWidth = 1
        brandImageView.layer.borderColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
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
