//
//  OnboardingCell.swift
//  forthgreen
//
//  Created by MACBOOK on 06/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell {

    // OUTLETS
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var skipBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        nextBtn.sainiCornerRadius(radius: 5)
    }

}
