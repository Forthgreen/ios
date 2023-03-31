//
//  AddPostVC.swift
//  forthgreen
//
//  Created by MACBOOK on 10/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown

protocol AddPostDeleagte {
    func dismissAddPost()
}

class AddPostVC: UploadMultipleImagesVC {
    
    var socialFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    private var TagListVM: TagListViewModel = TagListViewModel()
    private var images: Box<[UploadImageInfo]> = Box([UploadImageInfo]())
    private var postType: POST_TYPES = .text
    
    // OUTLETS
    @IBOutlet weak var bottomConstraintOfView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintOfPostTextView: NSLayoutConstraint!
    @IBOutlet weak var addPictureBtnView: UIView!
    @IBOutlet weak var addPicturesBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
  //  @IBOutlet weak var postTextLbl: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var postTextLbl: EasyMention!
    @IBOutlet weak var postTxtHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoThumbnailImg: UIImageView!
    @IBOutlet weak var constraintHeightVideoImg: NSLayoutConstraint!
    @IBOutlet weak var closeBtn: UIButton!
    
    var mentionItems = [MentionItem]()
    private var tagPage: Int = Int()
    
    var selectedVideo = UploadImageInfo.init()
    var deleagte : AddPostDeleagte?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        
       // postTextLbl.placeholder = "What do you want to share?"
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        deleagte?.dismissAddPost()
    }
    
    //MARK: - configUI
    private func configUI() {
        postBtn.sainiCornerRadius(radius: 16)
        addPicturesBtn.sainiCornerRadius(radius: 4)
        videoThumbnailImg.sainiCornerRadius(radius: 8)
        closeBtn.sainiCornerRadius(radius: 13)
        constraintHeightVideoImg.constant = SCREEN.WIDTH-36
        updatePostVideoButton()
        collectionView.register(UINib(nibName: COLLECTION_VIEW_CELL.postImageCell.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.postImageCell.rawValue)
        updatePostBtn(false)
        videoView.isHidden = true
        images.bind { [weak self](_) in
            guard let count = self?.images.value.count else { return }
//            if count >= 10 {
//                self?.addPictureBtnView.isHidden = true
//            }
//            else {
//                self?.addPictureBtnView.isHidden = false
//            }
            self?.updatePostBtn(count>=10)
            self?.collectionView.isHidden = false
            self!.videoView.isHidden = true
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        socialFeedVM.successForAddPost.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.socialFeedVM.successForAddPost.value {
                self.socialFeedVM.successForAddPost.value = false
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        self.postTextLbl.isFromBottom = true
        postTextLbl.textViewBorderColor = .clear
        postTextLbl.font = UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14)
        postTextLbl.mentionDelegate = self
        
  //      hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification(keyboardShowNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - handleKeyboardShowNotification
        @objc private func handleKeyboardShowNotification(keyboardShowNotification notification: Notification) {
            if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                print(keyboardRectangle.height)
                let safeArea = view.safeAreaInsets.bottom
                self.bottomConstraintOfView.constant = keyboardRectangle.height - safeArea//(DEVICE.IS_IPHONE_X ? 34 : 0)
            }
        }
    
    //MARK: - hideKeyboard
    @objc func hideKeyboard(notification: Notification) {
        self.bottomConstraintOfView.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    
    //MARK: - closeBtnIsPressed
    @IBAction func closeBtnIsPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickToCloseVideoView(_ sender: UIButton) {
        videoView.isHidden = true
        selectedVideo = UploadImageInfo.init()
        updatePostVideoButton()
    }
    
    @IBAction func clickToPlayVideo(_ sender: UIButton) {
        let vc : VideoPlayerVC = STORYBOARD.SOCIAL_FEED.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.selectedVideo = selectedVideo
        self.present(vc, animated: true) {}
    }
    
    //MARK: - postBtnIsPressed
    @IBAction func postBtnIsPressed(_ sender: UIButton) {
        var text = postTextLbl.text.trimmed //else { return }
        if text == DocumentDefaultValues.Empty.string && images.value.count == DocumentDefaultValues.Empty.int && selectedVideo.url == nil {
            self.view.sainiShowToast(message: STATIC_LABELS.emptyPostToast.rawValue)
        }
        else {
            
            var tagArr: [tagsRequest] = [tagsRequest]()
            if postTextLbl.getCurrentMentions().count != 0 {
                
                for item in postTextLbl.getCurrentMentions() {
                    let data = tagsRequest(id: item.id!, name: item.name, type: item.type ?? 1)
                    tagArr.append(data)
                }
            }
            
            var postType = POST_TYPES.text.rawValue
            if selectedVideo.url != nil {
                if text != "" {
                    postType = POST_TYPES.textWithVideo.rawValue
                }else{
                    postType = POST_TYPES.video.rawValue
                }
            }
            else if images.value.count > 0 {
                if text != "" {
                    postType = POST_TYPES.textWithImage.rawValue
                }else{
                    postType = POST_TYPES.image.rawValue
                }
            }
            
            var videoWidth : Float = 0
            var videoHeight : Float = 0
            if selectedVideo.url != nil {
                if let videoSize = resolutionForVideo(url: selectedVideo.url!) {
                    videoWidth = Float(videoSize.width)
                    videoHeight = Float(videoSize.height)
                }
            }
            let request = AddPostRequest.init(text: text, tags: tagArr, postType: postType, videoWidth: videoWidth, videoHeight: videoHeight)
            
//            let localPost = LocalPostData(text: text, tags: request.tags, imageData: images.value, video: selectedVideo)
            
            
            AppDelegate().sharedDelegate().addPost(request: request, imageData: images.value, video: selectedVideo)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - addPicturesBtnIsPressed
    @IBAction func addPicturesBtnIsPressed(_ sender: UIButton) {
        
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.black
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheet.addAction(cancelButton)
        
        let cameraButton = UIAlertAction(title: "Photo", style: .default)
        { _ in
            self.uploadImage()
        }
        actionSheet.addAction(cameraButton)
        
        let galleryButton = UIAlertAction(title: "Video", style: .default)
        { _ in
            self.uploadVideo()
        }
        actionSheet.addAction(galleryButton)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - selectedImages
    override func selectedImages(selectedImages: [UploadImageInfo]) {
        images.value += selectedImages
        if images.value.count > 0 { //|| postTextLbl.text.trimmed != DocumentDefaultValues.Empty.string || postTextLbl.text.trimmed != DocumentDefaultValues.Empty.string {
            updatePostBtn(true)
        }
        else {
            updatePostBtn(false)
        }
        updatePostVideoButton()
    }
    
    override func selectedVideo(_ video: URL) {
        videoView.isHidden = false
        collectionView.isHidden = true
        selectedVideo.url = video
        selectedVideo.name = "video"
        updatePostVideoButton()
        if let image = generateThumbnail(video) {
            videoThumbnailImg.image = image
            selectedVideo.image = image
        }
        if selectedVideo.url != nil {
            updatePostBtn(true)
        }else{
            updatePostBtn(false)
        }
        updatePostVideoButton()
    }
    
    //MARK: - clickedViaCamera
    override func clickedViaCamera(selectedImages: [UploadImageInfo]) {
        images.value += selectedImages
        if images.value.count >= 1 { //|| postTextLbl.text.trimmed != DocumentDefaultValues.Empty.string || postTextLbl.text.trimmed != DocumentDefaultValues.Empty.string{
            updatePostBtn(true)
        }
        else {
            updatePostBtn(false)
        }
        updatePostVideoButton()
    }
    
    func updatePostBtn(_ enable: Bool) {
        postBtn.isEnabled = enable
        postBtn.alpha = enable ? 1 : 0.5
    }
}

//MARK: - Collection View DataSource and Delegate Methods
extension AddPostVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.value.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.postImageCell.rawValue, for: indexPath) as? postImageCell else { return UICollectionViewCell() }
        cell.feedImage.sainiCornerRadius(radius: 8)
        cell.feedImage.image = images.value[indexPath.row].image
        cell.crossBtn.setImage(#imageLiteral(resourceName: "iconographyCloseWhite"), for: .normal)
        cell.crossBtn.backgroundColor = AppColors.charcol
        cell.crossBtn.sainiCornerRadius(radius: cell.crossBtn.frame.height / 2)
        cell.crossBtn.tag = indexPath.row
        cell.crossBtn.addTarget(self, action: #selector(crossBtnIsPressed), for: .touchUpInside)
        return cell
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellH = collectionView.frame.height
        let cellW = CGFloat(180)
        return CGSize(width: cellW, height: cellH)
    }
    
    //MARK: - crossBtnIsPressed
    @objc func crossBtnIsPressed(_ sender: UIButton) {
        images.value.remove(at: sender.tag)
        maxSelection = maxSelection + 1
        if images.value.count >= 1 || (postTextLbl.text.trimmed != DocumentDefaultValues.Empty.string && postTextLbl.text.trimmed != DocumentDefaultValues.Empty.string) {
            updatePostBtn(true)
        }
        else {
            updatePostBtn(false)
        }
        updatePostVideoButton()
    }
}

//MARK: - UITextViewDelegate
extension AddPostVC: UITextViewDelegate {
    // textViewDidBeginEditing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postTextLbl.text == DocumentDefaultValues.Empty.string{
            postTextLbl.text = DocumentDefaultValues.Empty.string
            postTextLbl.textColor = AppColors.charcol
            heightConstraintOfPostTextView.constant = 40
        }
    }
    
    // textViewDidChange
    func textViewDidChange(_ textView: UITextView) {
        var heightOfTextView = CGFloat()
        heightOfTextView = (postTextLbl.text.height(withConstrainedWidth: textView.frame.width, font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)!))
        heightConstraintOfPostTextView.constant = 40 + CGFloat(heightOfTextView)
    }
    
    // shouldChangeTextIn
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let text = textView.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: text)
            if updatedText.trimmed != DocumentDefaultValues.Empty.string {
                var heightOfTextView = CGFloat()
                heightOfTextView = (postTextLbl.text.height(withConstrainedWidth: textView.frame.width, font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)!))
                heightConstraintOfPostTextView.constant = 40 + CGFloat(heightOfTextView)
            }
            if updatedText.isEmpty { //&& images.value.count == 0 {
                updatePostBtn(false)
            }
            else {
                updatePostBtn(true)
            }
        }
        return true
    }
    
    // textViewDidEndEditing
    func textViewDidEndEditing(_ textView: UITextView) {
        if postTextLbl.text == DocumentDefaultValues.Empty.string {
            //postTextLbl.text = DocumentDefaultValues.Empty.string
            postTextLbl.textColor = AppColors.coolGray
        }
        bottomConstraintOfView.constant = 0
    }
    
    func updatePostVideoButton() {
        if selectedVideo.image == nil && images.value.count == 0 {
            addPicturesBtn.backgroundColor = PaleGrayColor
            addPicturesBtn.setTitleColor(BlackColor, for: .normal)
            addPicturesBtn.isUserInteractionEnabled = true
        }else{
            addPicturesBtn.backgroundColor = PaleGrayColor
            addPicturesBtn.setTitleColor(GrayColor, for: .normal)
            addPicturesBtn.isUserInteractionEnabled = false
        }
    }
}

extension AddPostVC: EasyMentionDelegate {
    func getPostText(in textView: String) {
        if textView.isEmpty && images.value.count == 0 {
            updatePostBtn(false)
        }
        else {
            updatePostBtn(true)
        }
        
        postTxtHeightConstraint.constant = self.postTextLbl.contentSize.height
        self.view.layoutIfNeeded()
    }
    
//    func removeMentioning(in textView: EasyMention, mentionQuery: MentionItem) {
//        print(mentionQuery)
//    }

    func mentionSelected(in textView: EasyMention, mention: MentionItem) {
        print(textView.getCurrentMentions())
    }
    
    func startMentioning(in textView: EasyMention, mentionQuery: String) {
        tagPage = 1
        TagListVM.getTagListing(request: TagListRequest(text: mentionQuery, page: tagPage, limit: 100)) { (users) in
            self.mentionItems.removeAll()
            users.forEach({ (user) in
                if user.id != "" {
                    self.mentionItems.append(MentionItem(name: user.name, id: user.id, imageURL: (AppImageUrl.small + user.image!), type: user.type!))
                }
            })
            self.postTextLbl.setMentions(mentions: self.mentionItems)
        }
    }
}
