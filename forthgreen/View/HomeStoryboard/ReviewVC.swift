//
//  ReviewVC.swift
//  forthgreen
//
//  Created by MACBOOK on 06/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ReviewVC: UIViewController, UITextViewDelegate {
    
    private var addReviewVM: AddReviewViewModel = AddReviewViewModel()
    private var addRestaurantReviewVM: AddRestaurantReviewViewModel = AddRestaurantReviewViewModel()
    var rating: Int = 0
    var productId: String = String()
    var reviewType: REVIEW_TYPE = .product
    
    @IBOutlet var bottomConstraintOfSubmitBtn: NSLayoutConstraint!
    @IBOutlet weak var starImage5: UIImageView!
    @IBOutlet weak var starImage4: UIImageView!
    @IBOutlet weak var starImage3: UIImageView!
    @IBOutlet weak var starImage2: UIImageView!
    @IBOutlet weak var starImage1: UIImageView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var reviewTxtViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var reviewTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        reviewTextField.isSelected = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        reviewTextField.isSelected = false
    }
    
    //MARK: - textViewDidChange
    func textViewDidChange(_ textView: UITextView) {
        reviewTextField.isSelected = false
        let maxHeight: CGFloat = 100.0
        let minHeight: CGFloat = 25.0
        reviewTxtViewHeightConstraint.constant = min(maxHeight, max(minHeight, textView.contentSize.height))
        self.view.layoutIfNeeded()
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        titleTextfield.sainiSetLeftPadding(12)
        titleTextfield.sainiSetRightPadding(12)
        submitBtn.layer.cornerRadius = 5
        starImage1Gesture()
        starImage2Gesture()
        starImage3Gesture()
        starImage4Gesture()
        starImage5Gesture()
        titleTextfield.becomeFirstResponder()
        
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification(keyboardShowNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - handleKeyboardShowNotification
    @objc private func handleKeyboardShowNotification(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.height)
            bottomConstraintOfSubmitBtn.constant = keyboardRectangle.height + 16
        }
    }
    
    @IBAction func clickToBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - hideKeyboard
    @objc func hideKeyboard(notification: Notification) {
        self.bottomConstraintOfSubmitBtn.constant = 16
    }
    
    //MARK: - starImage1Gesture
    func starImage1Gesture() {
        starImage1.sainiAddTapGesture {
            self.rating = 1
            self.starImage1.image = UIImage(named: "star_black_large")
            self.starImage2.image = UIImage(named: "star_white_large")
            self.starImage3.image = UIImage(named: "star_white_large")
            self.starImage4.image = UIImage(named: "star_white_large")
            self.starImage5.image = UIImage(named: "star_white_large")
        }
    }
    
    //MARK: - starImage2Gesture
    func starImage2Gesture() {
        starImage2.sainiAddTapGesture {
            self.rating = 2
            self.starImage1.image = UIImage(named: "star_black_large")
            self.starImage2.image = UIImage(named: "star_black_large")
            self.starImage3.image = UIImage(named: "star_white_large")
            self.starImage4.image = UIImage(named: "star_white_large")
            self.starImage5.image = UIImage(named: "star_white_large")
        }
    }
    
    //MARK: - starImage3Gesture
    func starImage3Gesture() {
        starImage3.sainiAddTapGesture {
            self.rating = 3
            self.starImage1.image = UIImage(named: "star_black_large")
            self.starImage2.image = UIImage(named: "star_black_large")
            self.starImage3.image = UIImage(named: "star_black_large")
            self.starImage4.image = UIImage(named: "star_white_large")
            self.starImage5.image = UIImage(named: "star_white_large")
        }
    }
    
    //MARK: - starImage4Gesture
    func starImage4Gesture() {
        starImage4.sainiAddTapGesture {
            self.rating = 4
            self.starImage1.image = UIImage(named: "star_black_large")
            self.starImage2.image = UIImage(named: "star_black_large")
            self.starImage3.image = UIImage(named: "star_black_large")
            self.starImage4.image = UIImage(named: "star_black_large")
            self.starImage5.image = UIImage(named: "star_white_large")
        }
    }
    
    //MARK: - starImage5Gesture
    func starImage5Gesture() {
        starImage5.sainiAddTapGesture {
            self.rating = 5
            self.starImage1.image = UIImage(named: "star_black_large")
            self.starImage2.image = UIImage(named: "star_black_large")
            self.starImage3.image = UIImage(named: "star_black_large")
            self.starImage4.image = UIImage(named: "star_black_large")
            self.starImage5.image = UIImage(named: "star_black_large")
        }
    }
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIBarButtonItem) {
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.moveIn
//        transition.subtype = CATransitionSubtype.fromBottom
//        self.navigationController?.view.layer.add(transition, forKey: nil)
        
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func submitBtnIsPressed(_ sender: UIButton) {
        self.addReviewVM.delegate = self
        self.addRestaurantReviewVM.delegate = self
        guard let title = titleTextfield.text else {
            titleTextfield.resignFirstResponder()
            self.view.sainiShowToast(message: "Title cannot be empty")
            return
        }
        guard let review = reviewTextView.text else {
            titleTextfield.resignFirstResponder()
            reviewTextView.resignFirstResponder()
            self.view.sainiShowToast(message: "Review cannot be empty")
            return
        }
        if rating == 0 {
            self.view.sainiShowToast(message: "Kindly add star ratings")
        }
        else if title == DocumentDefaultValues.Empty.string {
            self.view.sainiShowToast(message: "Kindly enter title of review")
        }
        else if review == DocumentDefaultValues.Empty.string {
            self.view.sainiShowToast(message: "Kindly enter your Review")
        }
        else {
            titleTextfield.resignFirstResponder()
            reviewTextView.resignFirstResponder()
            if reviewType == .product {
                let request = AddReviewRequest(productRef: productId, rating: rating, title: title, review: review)
                self.addReviewVM.addReview(reviewRequest: request)
            } else if reviewType == .restaurant {
                let request = AddReviewRequest(restaurantRef: productId, rating: rating, title: title, review: review)
                self.addRestaurantReviewVM.addReview(reviewRequest: request)
            }
        }
    }
    
}

//MARK: - AddReviewDelegate
extension ReviewVC: AddReviewDelegate {
    func didRecieveReviewResponse(response: AddReviewResponse) {
        log.success(response.message)/
        self.dismiss(animated: true) {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReviewSentVC") as! ReviewSentVC
            vc.backBtnType = .product
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

//MARK: - AddRestaurantReviewDelegate
extension ReviewVC: AddRestaurantReviewDelegate {
    func didRecieveRestaurantReviewResponse(response: AddReviewResponse) {
        log.success(response.message)/
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReviewSentVC") as! ReviewSentVC
        vc.backBtnType = .restaurant
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
