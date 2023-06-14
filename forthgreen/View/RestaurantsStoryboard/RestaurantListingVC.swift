//
//  RestaurantListingVC.swift
//  forthgreen
//
//  Created by MACBOOK on 01/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import MessageUI
import SainiUtils

class RestaurantListingVC: UIViewController {
    
    private var restaurantListingVM: RestaurantListingViewModel = RestaurantListingViewModel()
    private var locationManager: SainiLocationManager = SainiLocationManager()
    private let refreshControl = UIRefreshControl()
    var restaurantListArray: [RestaurantListing] = [RestaurantListing]()
    private var hasMore:Bool = false
    private var page = 1
    var longitude: Double = Double()
    var latitude: Double = Double()
    private var category = [Int]()
    
    // OUTLETS
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var NoDataLbl: UILabel!
    @IBOutlet weak var noResultsView: UIView!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        self.navigationItem.leftBarButtonItem?.isEnabled = false
//        self.navigationItem.leftBarButtonItem?.image = UIImage()
//        mapBtn.setBackgroundImage(UIImage.init(named: "buttob_back"), for: .normal, barMetrics: .default)
//        mapBtn.setTitleTextAttributes([.font : UIFont(name: "BuenosAires-Bold", size: 12)!, .foregroundColor : AppColors.charcol], for: .normal)
//        mapBtn.setTitleTextAttributes([.font : UIFont(name: "BuenosAires-Bold", size: 12)!, .foregroundColor : AppColors.charcol], for: .selected)
//        mapBtn.title = "MAP"
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: false)
        
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfTableView.constant = 76
        } else {
            bottomConstraintOfTableView.constant = 56
        }
    }
    
    //MARK: - configUI
    private func configUI() {
        mapBtn.sainiCornerRadius(radius: 16)
        noResultsView.isHidden = true
        
        tableView.register(UINib(nibName: "RestaurantNewTVC", bundle: nil), forCellReuseIdentifier: "RestaurantNewTVC")
        
        restaurantListingVM.delegate = self
        //        if AppModel.shared.isGuestUser{
        //            shimmerView.isHidden = true
        //            return
        //        }
        //        else{
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        restaurantListArray.removeAll()
        hasMore = false
        page = 1
        
        if let currentLocation = locationManager.exposedLocation {
            log.success("\(currentLocation)")/
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
            let request = RestaurantListRequest(longitude: longitude, latitude: latitude, categories: category, limit: 30, page: page)
            restaurantListingVM.fetchRestaurantListing(request: request)
        } else {
            self.view.sainiShowToast(message: "Kindly enable your location services.")
            
        }
        
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_ :)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:16/255, green:27/255, blue:57/255, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "")
        
        noRestaurantsToShowGesture()
        addAttributedText()
    }
    
    //MARK: - refreshData
    @objc func refreshData(_ sender: Any) {
//        restaurantListArray.removeAll()
//        shimmerView.isHidden = false
//        shimmerView.isSkeletonable = true
//        shimmerView.showAnimatedGradientSkeleton()
        hasMore = false
        page = 1
        if let currentLocation = locationManager.exposedLocation {
            log.success("\(currentLocation)")/
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
            let request = RestaurantListRequest(longitude: longitude, latitude: latitude, categories: category, limit: 30, page: page)
            restaurantListingVM.fetchRestaurantListing(request: request)
        }
    }
    
    //MARK: - addAttributedText
    private func addAttributedText() {
        let attributedText = NSMutableAttributedString(string: "There are no results in this location. Want to suggest a restaurant? ", attributes: [NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)!,NSAttributedString.Key.foregroundColor: AppColors.charcol])
        let underlineedText = underline(string: "Let us know.")
        attributedText.append(underlineedText)
        NoDataLbl.attributedText = attributedText
    }
    
    //MARK: - noRestaurantsToShow
    private func noRestaurantsToShowGesture() {
        NoDataLbl.sainiAddTapGesture {
            let openUrl = "https://forms.gle/kUaGDrvuxPyaX9ND7"
            guard let url = URL(string: openUrl) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //    //MARK: - restaurantSuggestionGesture
    //    private func restaurantSuggestionGesture() {
    //        restaurantSuggestionView.sainiAddTapGesture {
    //            if MFMailComposeViewController.canSendMail() {
    //                let mail = MFMailComposeViewController()
    //                mail.mailComposeDelegate = self
    //                mail.setToRecipients(["restaurants@forthgreen.com"])
    //                mail.setSubject("Restaurant suggestion")
    //                mail.setMessageBody("<b>Name: \(AppModel.shared.currentUser?.firstName ?? DocumentDefaultValues.Empty.string)<br/>", isHTML: true)
    //                self.present(mail, animated: true, completion: nil)
    //            } else {
    //                print("Cannot send mail")
    //                // give feedback to the user
    //            }
    //        }
    //    }
    
    //MARK: - filterBtnIsPressed
    @IBAction func filterBtnIsPressed(_ sender: UIBarButtonItem) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.delegate = self
        vc.filterType = .restaurants
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - mapBtnIsPressed
    @IBAction func mapBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "RestaurantMapVC") as! RestaurantMapVC
        vc.currentLocation = locationManager.exposedLocation?.coordinate
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension RestaurantListingVC: UITableViewDataSource, UITableViewDelegate {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantListArray.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantNewTVC", for: indexPath) as? RestaurantNewTVC else {
            return UITableViewCell()
        }
        if restaurantListArray.count > 0{
            cell.restaurantImageView.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.average + (restaurantListArray[indexPath.row].thumbnail))
            cell.restaurantNameLbl.text = restaurantListArray[indexPath.row].name
            cell.starRatingView.rating = restaurantListArray[indexPath.row].ratings?.averageRating ?? DocumentDefaultValues.Empty.double
            cell.ratingCountLbl.text = "\(restaurantListArray[indexPath.row].ratings?.count ?? DocumentDefaultValues.Empty.int)"
            cell.dishTypeLbl.text = restaurantListArray[indexPath.row].typeOfFood
            let count = restaurantListArray[indexPath.row].price.count
            print(count)
            let myString: NSString = "$$$"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "BuenosAires-Bold", size: 14.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.turqoiseGreen, range: NSRange(location:0,length:count))
            // set label Attribute
            cell.priceLbl.attributedText = myMutableString
            let distance = restaurantListArray[indexPath.row].distance * 0.00062137
            cell.distanceLbl.text = String(format: "%0.1f", distance) + " miles"
        }
        return cell
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
        vc.restaurantId = restaurantListArray[indexPath.row].id
        vc.distance = restaurantListArray[indexPath.row].distance
        vc.currentLocation = locationManager.exposedLocation?.coordinate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == restaurantListArray.count - 1 && hasMore == true{
            if let currentLocation = locationManager.exposedLocation {
                log.success("\(currentLocation)")/
                page += 1
                let latitude = currentLocation.coordinate.latitude
                let longitude = currentLocation.coordinate.longitude
                let request = RestaurantListRequest(longitude: longitude, latitude: latitude, categories: category, limit: 30, page: page)
                restaurantListingVM.fetchRestaurantListing(request: request)
            }
        }
    }
}

//MARK: - MFMailComposeViewControllerDelegate
extension RestaurantListingVC: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
            AppDelegate().sharedDelegate().showErrorToast(message: "feedback sent to admin successfully", true)
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: - RestaurantListingDelegate
extension RestaurantListingVC: RestaurantListingDelegate {
    func didRecieveRestaurantListResponse(response: RestaurantListingResponse) {
        log.success(response.message)/
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        self.refreshControl.endRefreshing()
        
        if page == 1 {
            restaurantListArray.removeAll()
        }
        
        hasMore = response.hasMore
        restaurantListArray += (response.data)
        var alreadyThere = Set<RestaurantListing>()
        let uniquePosts = restaurantListArray.compactMap { (post) -> RestaurantListing? in
            guard !alreadyThere.contains(post) else { return nil }
            alreadyThere.insert(post)
            return post
        }
        restaurantListArray = uniquePosts
        if restaurantListArray.count == 0 {
            noResultsView.isHidden = false
        }
        else {
            tableView.isHidden = false
            noResultsView.isHidden = true
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - FilterDelegate
extension RestaurantListingVC: FilterDelegate {
    func didRecieveFilterParams(category: [Int]) {
        self.category = category
        restaurantListArray.removeAll()
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        hasMore = false
        page = 1
        if let currentLocation = locationManager.exposedLocation {
            let latitude = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            let request = RestaurantListRequest(longitude: longitude, latitude: latitude, categories: category, limit: 30, page: page)
            restaurantListingVM.fetchRestaurantListing(request: request)
        }
    }
}

//MARK: - UITextFieldDelegate
extension RestaurantListingVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            restaurantListArray = [RestaurantListing]()
            hasMore = false
            page = 1
            let request = RestaurantListRequest(longitude: self.longitude, latitude: self.latitude, categories: self.category, text: updatedText, limit: 30, page: page)
            self.restaurantListingVM.fetchRestaurantListing(request: request)
        }
        return true
    }
}
