//
//  ReplyCell.swift
//  forthgreen
//
//  Created by MACBOOK on 10/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

class ReplyCell: UITableViewCell {
    
    //OUTLETS
    @IBOutlet weak var gotoLikeListBtn: UIButton!
    @IBOutlet weak var gotoProfileBtn2: UIButton!
    @IBOutlet weak var gotoProfileBtn: UIButton!
    @IBOutlet weak var heightConstraintOfViewMoreBtnView: NSLayoutConstraint!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var threeDotsBtn: UIButton!
    @IBOutlet weak var viewMoreBtnView: UIView!
    @IBOutlet weak var viewMoreBtn: UIButton!
    @IBOutlet weak var replyTextLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var locationManager: SainiLocationManager = SainiLocationManager()
    
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
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        replyTextLbl.isUserInteractionEnabled = true
        replyTextLbl.addGestureRecognizer(tapAction)
    }
    
    var replyList: CommentList = CommentList() {
        didSet {
            threeDotsBtn.isHidden = replyList.addedBy.dummyUser
            profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.average + replyList.addedBy.image)
            nameLbl.text = "\(replyList.addedBy.firstName)" //" \(replyList.addedBy.lastName)"
            likeCountLbl.text = "\(replyList.likes)"
            
            if replyList.isLike {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES_SMALL.liked.rawValue), for: .normal)
            }
            else {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES_SMALL.notLiked.rawValue), for: .normal)
            }
            
            replyTextLbl.attributedText = attributedStringWithColor(replyList.comment, replyList.tags.map({ $0.name }), color: colorFromHex(hex: "#3A86FF"), font: UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14.0))
            
            replyList.postTextLineCount = replyTextLbl.calculateMaxLines()
            if replyList.postTextLineCount > 3 && replyList.isTextExpanded == false{
                replyTextLbl.numberOfLines = 3
                viewMoreBtnView.isHidden = false
                heightConstraintOfViewMoreBtnView.constant = 20
            }
            
            else {
                replyTextLbl.numberOfLines = replyList.postTextLineCount
                viewMoreBtnView.isHidden = true
                heightConstraintOfViewMoreBtnView.constant = 0
            }
        }
    }
    
    var replyInfo: Reply = Reply() {
        didSet {
            threeDotsBtn.isHidden = replyInfo.addedBy.dummyUser
            profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.average + replyInfo.addedBy.image)
            nameLbl.text = "\(replyInfo.addedBy.firstName)" // \(replyInfo.addedBy.lastName)"
            likeCountLbl.text = "\(replyInfo.likes)"
            
            if replyInfo.isLike {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES_SMALL.liked.rawValue), for: .normal)
            }
            else {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES_SMALL.notLiked.rawValue), for: .normal)
            }
            replyTextLbl.text = replyInfo.comment
            replyInfo.postTextLineCount = replyTextLbl.calculateMaxLines()
            if replyInfo.postTextLineCount > 3 && replyInfo.isTextExpanded == false{
                replyTextLbl.numberOfLines = 3
                viewMoreBtnView.isHidden = false
                heightConstraintOfViewMoreBtnView.constant = 20
            }
            
            else {
                replyTextLbl.numberOfLines = replyInfo.postTextLineCount
                viewMoreBtnView.isHidden = true
                heightConstraintOfViewMoreBtnView.constant = 0
            }
        }
    }
    
    @objc @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        if replyList.tags.count == 0 {
            return
        }
        
        let index = replyList.tags.firstIndex { (temp) -> Bool in
            gesture.didTapAttributedTextInLabel(label: replyTextLbl, targetText: temp.name)
        }
        if index != nil {
            if replyList.tags[index!].type == TAG_TYPES.USERS.rawValue {
                let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
                vc.userId = replyList.tags[index!].id
                vc.userIsFrom = .home
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if replyList.tags[index!].type == TAG_TYPES.RESTAURANTS.rawValue {
                let vc = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
                vc.restaurantId = replyList.tags[index!].id
           //     vc.distance = restaurantListArray[indexPath.row].distance
                vc.currentLocation = locationManager.exposedLocation?.coordinate
                
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if replyList.tags[index!].type == TAG_TYPES.BRAND.rawValue {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandDetailVC") as! BrandDetailVC
                vc.brandId = replyList.tags[index!].id
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
}
