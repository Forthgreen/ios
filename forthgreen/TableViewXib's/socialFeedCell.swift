//
//  socialFeedCell.swift
//  forthgreen
//
//  Created by MACBOOK on 07/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils
import AVKit
import AVFoundation

class socialFeedCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
    
    private var images: [String] = [String]()
    var postType: POST_TYPES = .text
    var fromSocialFeed: Bool = Bool()
    
    // OUTLETS
    @IBOutlet weak var goToLikeListBtn: UIButton!
    @IBOutlet weak var gotoCommentListBtn: UIButton!
    @IBOutlet weak var postTextView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightConstraintOfViewMoreBtnView: NSLayoutConstraint!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var addCommentBtn: UIButton!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var postImagesView: UIView!
    @IBOutlet weak var viewMoreBtnView: UIView!
    @IBOutlet weak var viewMoreBtn: UIButton!
    @IBOutlet weak var postTxtLbl: UILabel!
    @IBOutlet weak var threeDotBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var likesBackView: UIView!
    @IBOutlet weak var othersLikeLbl: UILabel!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var constraintHeightVideoView: NSLayoutConstraint!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var videoImgView: UIImageView!
    @IBOutlet weak var soundBtn: UIButton!
    @IBOutlet weak var videoLoader: UIActivityIndicatorView!
    
    var locationManager: SainiLocationManager = SainiLocationManager()
    
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    var myVideoView: UIView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self, selector: #selector(videoStartPlaying), name: NSNotification.Name.init(NOTIFICATIONS.VideoPlay.rawValue), object: nil)
        configUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func videoStartPlaying(_ noti: Notification) {
        if let dict = noti.object as? [String : Any] {
            if let url = dict["video_url"] as? String, url == videoURL {
                videoLoader.stopAnimating()
                videoLoader.isHidden = true
                delay(0.2) {
                    self.videoImgView.isHidden = true
                }
                
                dictVideoLoad[url] = true
            }
        }
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(playerView.frame, from: playerView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
    //MARK: - configUI
    private func configUI() {
        profileImageView.sainiCornerRadius(radius: profileImageView.frame.height / 2)
        collectionView.register(UINib(nibName: COLLECTION_VIEW_CELL.postImageCell.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.postImageCell.rawValue)
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        postTxtLbl.isUserInteractionEnabled = true
        postTxtLbl.addGestureRecognizer(tapAction)
        
        
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerView.layer.addSublayer(videoLayer)
        constraintHeightVideoView.constant = SCREEN.WIDTH
        myVideoView = videoView
        videoLayer.player?.isMuted = isMuteVideo
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if postType == .video || postType == .textWithVideo {
//            var playerHeight = SCREEN.WIDTH
//            videoLayer.frame = CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: playerHeight)
        }
    }
    
    var postInfo: SocialFeed = SocialFeed() {
        didSet {
            images = postInfo.image
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            likesBackView.isHidden = true
            
            timeLbl.text = getDifferenceFromCurrentTimeInHourInDays(postInfo.createdOn)
            if fromSocialFeed {
                profileImageView.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.average + postInfo.addedBy.image)
                nameLbl.text = postInfo.addedBy.firstName //+ " \(postInfo.addedBy.lastName)"
//                userNameLbl.isHidden = true
//                userNameLbl.text = STATIC_LABELS.atTheRate.rawValue + "\(postInfo.addedBy.username)"
                 
                
//                if postInfo.whoLiked.count != 0 {
//                    if getLikedString(likeData: postInfo.whoLiked) != "" {
//                        likesBackView.isHidden = false
//                        othersLikeLbl.attributedText = attributedStringWithColor(getLikedString(likeData: postInfo.whoLiked), postInfo.whoLiked.map({ $0.firstName }), color: .black, font: UIFont.init(name: APP_FONT.buenosAiresBold.rawValue, size: 12.0), lineSpacing: 2)
//                    }
//                    else{
//                        likesBackView.isHidden = true
//                    }
//                }
            }
            
            threeDotBtn.isHidden = postInfo.addedBy.dummyUser
            
            if postInfo.image.count == 1 {
                pageControl.isHidden = true
            }
            else {
                pageControl.isHidden = false
                pageControl.numberOfPages = postInfo.image.count
            }
            
            if postInfo.isLike {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES.liked.rawValue), for: .normal)
            }
            else {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES.notLiked.rawValue), for: .normal)
            }
            commentCountLbl.text = "\(postInfo.comments)"
            likeCountLbl.text = "\(postInfo.likes )"
            
            postTextView.isHidden = true
            postImagesView.isHidden = true
            postTxtLbl.isHidden = true
            viewMoreBtnView.isHidden = true
            videoView.isHidden = true
            videoImgView.isHidden = true
            soundBtn.isHidden = true
            soundBtn.isSelected = isMuteVideo
            
            postType = POST_TYPES(rawValue: postInfo.type ?? DocumentDefaultValues.Empty.int) ?? .text
            switch postType {
            case .image:
                postImagesView.isHidden = false
            case .text:
                postTextView.isHidden = false
                postTxtLbl.isHidden = false
                
                postTxtLbl.attributedText = attributedStringWithColor(postInfo.text, postInfo.tags.map({ $0.name }), color: colorFromHex(hex: "#3A86FF"), font: UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14.0), lineSpacing: 5)
                
       //         postTxtLbl.increaseLineSpacing(text: postInfo.text)
                postInfo.postTextLineCount = postTxtLbl.calculateMaxLines()
                if postInfo.postTextLineCount > 3 && postInfo.isTextExpanded == false{
                    postTxtLbl.numberOfLines = 3
                    viewMoreBtn.isHidden = false
                    viewMoreBtnView.isHidden = false
                    heightConstraintOfViewMoreBtnView.constant = 20
                }
                else {
                    postTxtLbl.numberOfLines = postInfo.postTextLineCount
                    viewMoreBtnView.isHidden = true
                    viewMoreBtn.isHidden = true
                    heightConstraintOfViewMoreBtnView.constant = 0
                }
            case .textWithImage:
                postTextView.isHidden = false
                postTxtLbl.isHidden = false
                postImagesView.isHidden = false
                
                postTxtLbl.attributedText = attributedStringWithColor(postInfo.text, postInfo.tags.map({ $0.name }), color: colorFromHex(hex: "#3A86FF"), font: UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14.0), lineSpacing: 5)
                
            //    postTxtLbl.increaseLineSpacing(text: postInfo.text)
                postInfo.postTextLineCount = postTxtLbl.calculateMaxLines()
                if postInfo.postTextLineCount > 3 && postInfo.isTextExpanded == false{
                    postTxtLbl.numberOfLines = 3
                    viewMoreBtnView.isHidden = false
                    viewMoreBtn.isHidden = false
                    heightConstraintOfViewMoreBtnView.constant = 20
                }
                else {
                    postTxtLbl.numberOfLines = postInfo.postTextLineCount
                    viewMoreBtnView.isHidden = true
                    viewMoreBtn.isHidden = true
                    heightConstraintOfViewMoreBtnView.constant = 0
                }
            case .user:
                break
            case .video:
                videoView.isHidden = false
                soundBtn.isHidden = false

                if postInfo.video != "" {
                    videoURL = AppVideoUrl.VIDEO_BASE + postInfo.video
                    playerView.isHidden = false
                    if let temp = dictVideoLoad[videoURL!], temp == true {
                        videoLoader.isHidden = true
                    }else{
                        videoLoader.startAnimating()
                        videoLoader.isHidden = false
                    }
                }else{
                    playerView.isHidden = true
                }
                if postInfo.thumbnail != "" {
                    videoImgView.isHidden = false
                    videoImgView.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProducts.rawValue, urlString: AppImageUrl.average + postInfo.thumbnail)
                    
//                    if ASVideoPlayerController.sharedVideoPlayer.observingURLs[videoURL!] == true {
//                        self.videoImgView.isHidden = true
//                    }
//                    else{
//                        delay(2.0) {
//                            self.videoImgView.isHidden = true
//                        }
//                    }
                }else{
                    videoImgView.isHidden = true
                }
                break
            case .textWithVideo:
                postTextView.isHidden = false
                postTxtLbl.isHidden = false
                videoView.isHidden = false
                soundBtn.isHidden = false
                
                postTxtLbl.attributedText = attributedStringWithColor(postInfo.text, postInfo.tags.map({ $0.name }), color: colorFromHex(hex: "#3A86FF"), font: UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14.0), lineSpacing: 5)
                
            //    postTxtLbl.increaseLineSpacing(text: postInfo.text)
                postInfo.postTextLineCount = postTxtLbl.calculateMaxLines()
                if postInfo.postTextLineCount > 3 && postInfo.isTextExpanded == false{
                    postTxtLbl.numberOfLines = 3
                    viewMoreBtnView.isHidden = false
                    viewMoreBtn.isHidden = false
                    heightConstraintOfViewMoreBtnView.constant = 20
                }
                else {
                    postTxtLbl.numberOfLines = postInfo.postTextLineCount
                    viewMoreBtnView.isHidden = true
                    viewMoreBtn.isHidden = true
                    heightConstraintOfViewMoreBtnView.constant = 0
                }
                if postInfo.video != "" {
                    videoURL = AppVideoUrl.VIDEO_BASE + postInfo.video
                    playerView.isHidden = false
                    if let temp = dictVideoLoad[videoURL!], temp == true {
                        videoLoader.isHidden = true
                    }else{
                        videoLoader.startAnimating()
                        videoLoader.isHidden = false
                    }
                }else{
                    playerView.isHidden = true
                }
                if postInfo.thumbnail != "" {
                    videoImgView.isHidden = false
                    videoImgView.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProducts.rawValue, urlString: AppImageUrl.average + postInfo.thumbnail)
//                    if ASVideoPlayerController.sharedVideoPlayer.observingURLs[videoURL!] == true {
//                        delay(0.1) {
//                            self.videoImgView.isHidden = true
//                        }
//                    }
//                    else{
//                        delay(2.0) {
//                            self.videoImgView.isHidden = true
//                        }
//                    }
                }else{
                    videoImgView.isHidden = true
                }
                break
            }
            
            if postType == .video || postType == .textWithVideo {
                if let height = dictVideoHeight[postInfo.id] {
                    constraintHeightVideoView.constant = CGFloat(height)
                }
                else{
                    if postInfo.videoHeight > 0 {
                        constraintHeightVideoView.constant = CGFloat(Double(SCREEN.WIDTH)*postInfo.videoHeight/postInfo.videoWidth)
                    }else{
                        constraintHeightVideoView.constant = SCREEN.WIDTH
                    }
                    dictVideoHeight[postInfo.id] = Float(constraintHeightVideoView.constant)
                }
                videoLayer.frame = CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: constraintHeightVideoView.constant)
//                constraintHeightVideoView.constant = SCREEN.WIDTH
            }
        }
    }
    
    var postDetail: Posts = Posts() {
        didSet {
            images = postDetail.image
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            likesBackView.isHidden = true
            
            threeDotBtn.isHidden = postDetail.addedBy.dummyUser
            profileImageView.downloadCachedImageWithLoader(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: AppImageUrl.average + postDetail.addedBy.image)
            nameLbl.text = postDetail.addedBy.firstName// + " \(postDetail.addedBy.lastName)"
//            if postDetail.addedBy.username == DocumentDefaultValues.Empty.string {
//                userNameLbl.isHidden = true
//            }
//            else {
            timeLbl.text = getDifferenceFromCurrentTimeInHourInDays(postDetail.createdOn)
//                userNameLbl.isHidden = false
//            }
            
            if postDetail.image.count == 1 {
                pageControl.isHidden = true
            }
            else {
                pageControl.isHidden = false
                pageControl.numberOfPages = postDetail.image.count
            }
            
            if postDetail.isLike {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES.liked.rawValue), for: .normal)
            }
            else {
                likeBtn.setImage(UIImage(named: LIKE_POST_IMAGES.notLiked.rawValue), for: .normal)
            }
            commentCountLbl.text = "\(postDetail.comments)"
            likeCountLbl.text = "\(postDetail.likes )"
            
            postTextView.isHidden = true
            postImagesView.isHidden = true
            postTxtLbl.isHidden = true
            viewMoreBtnView.isHidden = true
            videoView.isHidden = true
            videoImgView.isHidden = true
            soundBtn.isHidden = true
            soundBtn.isSelected = isMuteVideo
            
            postType = POST_TYPES(rawValue: postDetail.type) ?? .text
            switch postType {
            case .image:
                postImagesView.isHidden = false
            case .text:
                postTextView.isHidden = false
                postTxtLbl.isHidden = false
//                postTxtLbl.text = postDetail.text
//                postTxtLbl.increaseLineSpacing(text: postDetail.text)
                postTxtLbl.attributedText = attributedStringWithColor(postDetail.text, postDetail.tags.map({ $0.name }), color: colorFromHex(hex: "#3A86FF"), font: UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14.0), lineSpacing: 5)
                postDetail.postTextLineCount = postTxtLbl.calculateMaxLines()
                if postDetail.postTextLineCount > 3 && postDetail.isTextExpanded == false{
                    postTxtLbl.numberOfLines = 3
                    viewMoreBtnView.isHidden = false
                    viewMoreBtn.isHidden = false
                    heightConstraintOfViewMoreBtnView.constant = 20
                }
                
                else {
                    postTxtLbl.numberOfLines = postDetail.postTextLineCount
                    heightConstraintOfViewMoreBtnView.constant = 0
                }
            case .textWithImage:
                postTextView.isHidden = false
                postTxtLbl.isHidden = false
                postImagesView.isHidden = false
//                postTxtLbl.increaseLineSpacing(text: postDetail.text)
                postTxtLbl.attributedText = attributedStringWithColor(postDetail.text, postDetail.tags.map({ $0.name }), color: colorFromHex(hex: "#3A86FF"), font: UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14.0), lineSpacing: 5)
                postDetail.postTextLineCount = postTxtLbl.calculateMaxLines()
                if postDetail.postTextLineCount > 3 && postDetail.isTextExpanded == false{
                    postTxtLbl.numberOfLines = 3
                    viewMoreBtnView.isHidden = false
                    heightConstraintOfViewMoreBtnView.constant = 20
                }
                else {
                    postTxtLbl.numberOfLines = postDetail.postTextLineCount
                    heightConstraintOfViewMoreBtnView.constant = 0
                }
            case .user:
                break
            case .video:
                videoView.isHidden = false
                soundBtn.isHidden = false
                
                
                if postDetail.video != "" {
                    videoURL = AppVideoUrl.VIDEO_BASE + postDetail.video
                    playerView.isHidden = false
                    if let temp = dictVideoLoad[videoURL!], temp == true {
                        videoLoader.isHidden = true
                    }else{
                        videoLoader.startAnimating()
                        videoLoader.isHidden = false
                    }
                }else{
                    playerView.isHidden = true
                }
                if postDetail.thumbnail != "" {
                    videoImgView.isHidden = false
                    videoImgView.downloadCachedImageWithLoader(placeholder: GLOBAL_IMAGES.placeholderForProducts.rawValue, urlString: AppImageUrl.average + postDetail.thumbnail)
                }else{
                    videoImgView.isHidden = true
                }
//                if ASVideoPlayerController.sharedVideoPlayer.observingURLs[videoURL!] == true {
//                    delay(0.1) {
//                        self.videoImgView.isHidden = true
//                    }
//                }
//                else{
//                    delay(2.0) {
//                        self.videoImgView.isHidden = true
//                    }
//                }
                break
            case .textWithVideo:
                
                postTextView.isHidden = false
                postTxtLbl.isHidden = false
                videoView.isHidden = false
                soundBtn.isHidden = false
                
                if postDetail.video != "" {
                    videoURL = AppVideoUrl.VIDEO_BASE + postDetail.video
                    playerView.isHidden = false
                    if let temp = dictVideoLoad[videoURL!], temp == true {
                        videoLoader.isHidden = true
                    }else{
                        videoLoader.startAnimating()
                        videoLoader.isHidden = false
                    }
                }else{
                    playerView.isHidden = true
                }
                
                postTxtLbl.attributedText = attributedStringWithColor(postDetail.text, postDetail.tags.map({ $0.name }), color: colorFromHex(hex: "#3A86FF"), font: UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14.0), lineSpacing: 5)
                
                postDetail.postTextLineCount = postTxtLbl.calculateMaxLines()
                if postDetail.postTextLineCount > 3 && postDetail.isTextExpanded == false{
                    postTxtLbl.numberOfLines = 3
                    viewMoreBtnView.isHidden = false
                    viewMoreBtn.isHidden = false
                    heightConstraintOfViewMoreBtnView.constant = 20
                }
                else {
                    postTxtLbl.numberOfLines = postDetail.postTextLineCount
                    viewMoreBtnView.isHidden = true
                    viewMoreBtn.isHidden = true
                    heightConstraintOfViewMoreBtnView.constant = 0
                }
                
                if postDetail.thumbnail != "" {
                    videoImgView.isHidden = false
                    videoImgView.downloadCachedImageWithLoader(placeholder: GLOBAL_IMAGES.placeholderForProducts.rawValue, urlString: AppImageUrl.average + postDetail.thumbnail)
//                    if ASVideoPlayerController.sharedVideoPlayer.observingURLs[videoURL!] == true {
//                        delay(0.1) {
//                            self.videoImgView.isHidden = true
//                        }
//                    }
//                    else{
//                        delay(2.0) {
//                            self.videoImgView.isHidden = true
//                        }
//                    }
                }else{
                    videoImgView.isHidden = true
                }
                break
            }
            if postType == .video || postType == .textWithVideo {
                
                if let height = dictVideoHeight[postDetail.id] {
                    constraintHeightVideoView.constant = CGFloat(height)
                }
                else{
                    if postDetail.videoHeight > 0 {
                        constraintHeightVideoView.constant = CGFloat(Double(SCREEN.WIDTH)*postDetail.videoHeight/postDetail.videoWidth)
                    }else{
                        constraintHeightVideoView.constant = SCREEN.WIDTH
                    }
                    dictVideoHeight[postDetail.id] = Float(constraintHeightVideoView.constant)
                }
                videoLayer.frame = CGRect(x: 0, y: 0, width: SCREEN.WIDTH, height: constraintHeightVideoView.constant)
//                constraintHeightVideoView.constant = SCREEN.WIDTH
            }
        }
    }
    
    @IBAction func clickToMuteUnmute(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isMuteVideo = !isMuteVideo
        videoLayer.player?.isMuted = isMuteVideo
    }
    
    @objc @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        if postInfo.tags.count == 0 {
            return
        }
        
        let index = postInfo.tags.firstIndex { (temp) -> Bool in
          //  commentTextLbl.text?.contains(temp.name)
            gesture.didTapAttributedTextInLabel(label: postTxtLbl, targetText: temp.name)
        }
        if index != nil {
            if postInfo.tags[index!].type == TAG_TYPES.USERS.rawValue {
                let vc = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: SOCIAL_FEED_STORYBOARD.OtherUserProfileVC.rawValue) as! OtherUserProfileVC
                vc.userId = postInfo.tags[index!].id
                vc.userIsFrom = .home
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if postInfo.tags[index!].type == TAG_TYPES.RESTAURANTS.rawValue {
                let vc = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
                vc.restaurantId = postInfo.tags[index!].id
                vc.isTransition = true
           //     vc.distance = restaurantListArray[indexPath.row].distance
                vc.currentLocation = locationManager.exposedLocation?.coordinate
                
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if postInfo.tags[index!].type == TAG_TYPES.BRAND.rawValue {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandDetailVC") as! BrandDetailVC
                vc.brandId = postInfo.tags[index!].id
                vc.isTransition = true
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func getLikedString(likeData: [AddedBy]) -> String {
        var str: String = String()
        if likeData.count == 1 {
            str = "\(likeData[0].firstName) likes this"
        }
        else if likeData.count == 2 {
            str = "\(likeData[0].firstName) and \(likeData[1].firstName) likes this"
        }
        return str
    }
    
}

//MARK: - Collection View DataSource and Delegate Methods
extension socialFeedCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.postImageCell.rawValue, for: indexPath) as? postImageCell else { return UICollectionViewCell() }
        cell.crossBtnView.isHidden = true
        cell.feedImage.downloadCachedImageWithLoader(placeholder: GLOBAL_IMAGES.placeholderForProducts.rawValue, urlString: AppImageUrl.best + images[indexPath.row])
        return cell
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellH = collectionView.frame.height
        let cellW = collectionView.frame.width
        return CGSize(width: cellW, height: cellH)
    }
}

//MARK: - UIScrollViewDelegate
extension socialFeedCell : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
}
