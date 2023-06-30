//
//  CommentCell.swift
//  forthgreen
//
//  Created by MACBOOK on 09/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

class CommentCell: UITableViewCell {
    
    // OUTLETS
    @IBOutlet weak var goToLikeListBtn: UIButton!
    @IBOutlet weak var gotoReplyBtn: UIButton!
    @IBOutlet weak var gotoProfileBtn2: UIButton!
    @IBOutlet weak var gotoProfileBtn: UIButton!
    @IBOutlet weak var heightConstraintOfViewMoreBtnView: NSLayoutConstraint!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var addReplyBtn: UIButton!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var threeDotsBtn: UIButton!
    @IBOutlet weak var viewMoreBtnView: UIView!
    @IBOutlet weak var viewMoreBtn: UIButton!
    @IBOutlet weak var commentTextLbl: UILabel!
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
        commentTextLbl.isUserInteractionEnabled = true
        commentTextLbl.addGestureRecognizer(tapAction)
    }
    
    var commentList: CommentList = CommentList() {
        didSet {
            threeDotsBtn.isHidden = commentList.addedBy.dummyUser
            
            profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.average + commentList.addedBy.image)
            nameLbl.text = "\(commentList.addedBy.firstName)"// \(commentList.addedBy.lastName)"
//            commentCountLbl.text = "\(commentList.reply)"
            likeCountLbl.text = "\(commentList.likes)"
            
            if commentList.isLike {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES_SMALL.liked.rawValue), for: .normal)
            }
            else {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES_SMALL.notLiked.rawValue), for: .normal)
            }
            
            commentTextLbl.attributedText = attributedStringWithColor(commentList.comment,
                                                                      commentList.tags.map({ $0.name }),
                                                                      color: colorFromHex(hex: "#000000"), font: UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14.0), lineSpacing: 5)
            
            
            
            commentList.postTextLineCount = commentTextLbl.calculateMaxLines()
            if commentList.postTextLineCount > 3 && commentList.isTextExpanded == false{
                commentTextLbl.numberOfLines = 3
                viewMoreBtnView.isHidden = false
                heightConstraintOfViewMoreBtnView.constant = 20
            }
            
            else {
                commentTextLbl.numberOfLines = commentList.postTextLineCount
                viewMoreBtnView.isHidden = true
                heightConstraintOfViewMoreBtnView.constant = 0
            }
        }
    }
    
    var commentInfo: Comment = Comment() {
        didSet {
            threeDotsBtn.isHidden = commentInfo.addedBy.dummyUser
            profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.average + commentInfo.addedBy.image)
            nameLbl.text = "\(commentInfo.addedBy.firstName)" //" \(commentInfo.addedBy.lastName)"
//            commentCountLbl.text = "\(commentInfo.replies)"
            likeCountLbl.text = "\(commentInfo.likes)"
            
            if commentInfo.isLike {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES_SMALL.liked.rawValue), for: .normal)
            }
            else {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES_SMALL.notLiked.rawValue), for: .normal)
            }
            
            commentTextLbl.text = commentInfo.comment
            commentInfo.postTextLineCount = commentTextLbl.calculateMaxLines()
            if commentInfo.postTextLineCount > 3 && commentInfo.isTextExpanded == false{
                commentTextLbl.numberOfLines = 3
                viewMoreBtnView.isHidden = false
                heightConstraintOfViewMoreBtnView.constant = 20
            }
            
            else {
                commentTextLbl.numberOfLines = commentInfo.postTextLineCount
                viewMoreBtnView.isHidden = true
                heightConstraintOfViewMoreBtnView.constant = 0
            }
        }
    }
    
    @objc @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        if commentList.tags.count == 0 {
            return
        }
        
        let index = commentList.tags.firstIndex { (temp) -> Bool in
          //  commentTextLbl.text?.contains(temp.name)
            gesture.didTapAttributedTextInLabel(label: commentTextLbl, targetText: temp.name)
        }
        if index != nil {
            if commentList.tags[index!].type == TAG_TYPES.USERS.rawValue {
                let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
                vc.userId = commentList.tags[index!].id
                vc.userIsFrom = .home
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if commentList.tags[index!].type == TAG_TYPES.RESTAURANTS.rawValue {
                let vc = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
                vc.restaurantId = commentList.tags[index!].id
           //     vc.distance = restaurantListArray[indexPath.row].distance
                vc.currentLocation = locationManager.exposedLocation?.coordinate
                
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if commentList.tags[index!].type == TAG_TYPES.BRAND.rawValue {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandDetailVC") as! BrandDetailVC
                vc.brandId = commentList.tags[index!].id
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
