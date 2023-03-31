//
//  SearchVC.swift
//  forthgreen
//
//  Created by MACBOOK on 17/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

class SearchVC: UIViewController {
    
    private var searchVM: SearchViewModel = SearchViewModel()
    private var restaurantListingVM: RestaurantListingViewModel = RestaurantListingViewModel()
    var searchArray: SearchData?
    var restaurantListArray: [RestaurantListing] = [RestaurantListing]()
    var searchType: REVIEW_TYPE = .product
    var longitude: Double = Double()
    var latitude: Double = Double()
    private var workItemReferance: DispatchWorkItem?
    private var searchedText: String = String()
    private var page: Int = Int()
    private var hasMore: Bool = false
    
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchBarView: sainiCardView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintHeightTblView: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // customTabBar
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
    }

    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - viewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchTextfield.becomeFirstResponder()
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        
//        searchBarView.layer.borderWidth = 1
//        searchBarView.layer.borderColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
        tableView.register(UINib(nibName: "BrandListCell", bundle: nil), forCellReuseIdentifier: "BrandListCell")
        tableView.register(UINib(nibName: "restaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
        searchVM.delegate = self
        restaurantListingVM.delegate = self
        page = 1
        hasMore = false
        if searchType == .product {
            let request = SearchRequest(text: searchedText, paginationToken: false, page: page, limit: 25)
            searchVM.search(searchRequest: request)
        } else if searchType == .restaurant {
            // resturant
            let request = RestaurantListRequest(longitude: longitude, latitude: latitude, categories: [], text: searchedText)
            restaurantListingVM.fetchRestaurantListing(request: request)
        }
    }
    
    //MARK: - cancelBtnIsPressed
    @IBAction func cancelBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: - UITextFieldDelegate
extension SearchVC: UITextFieldDelegate {
    // shouldChangeCharactersIn
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText != DocumentDefaultValues.Empty.string {
                workItemReferance?.cancel()
                let workItem = DispatchWorkItem {
                    self.shimmerView.isHidden = false
                    self.shimmerView.isSkeletonable = true
                    self.shimmerView.showAnimatedGradientSkeleton()
                    self.searchArray?.list.removeAll()
                    self.searchedText = updatedText.trimmed
                    if self.searchType == .product {
                        let request = SearchRequest(text: self.searchedText, paginationToken: false, page: self.page, limit: 25)
                        self.searchVM.search(searchRequest: request)
                    } else if self.searchType == .restaurant {
                        // restaurant
                        let request = RestaurantListRequest(longitude: self.longitude, latitude: self.latitude, categories: [], text: self.searchedText)
                        self.restaurantListingVM.fetchRestaurantListing(request: request)
                    }
                }
                workItemReferance = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1),execute: workItem)
            }
        }
        return true
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchType == .product {
            if searchArray?.list.count == 0 {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.emptySearchMsg.rawValue)
                return 0
            }
            tableView.restore()
            tableView.separatorStyle = .none
            return searchArray?.list.count ?? 0
        } else if searchType == .restaurant {
            if restaurantListArray.count == 0 {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.emptySearchMsg.rawValue)
                return 0
            }
            tableView.restore()
            tableView.separatorStyle = .none
            return restaurantListArray.count
        }
        else {
            return 0
        }
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchType == .product {
            return 100
        } else {
            return 120
        }
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchType == .product {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrandListCell", for: indexPath) as? BrandListCell else {
                return UITableViewCell()
            }
            if searchArray?.list[indexPath.row].isProduct ?? false {
                cell.renderProfileImage(circle: false)
                cell.followersCountLbl.isHidden = false
                cell.priceLbl.isHidden = false
                cell.priceLbl.text = searchArray?.list[indexPath.row].price
                cell.brandNameLbl.text = searchArray?.list[indexPath.row].name
                cell.followersCountLbl.text = searchArray?.list[indexPath.row].brand?.name
                cell.brandImage.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.average + (searchArray?.list[indexPath.row].images?.first ?? ""))
            }
            else {
                cell.renderProfileImage(circle: true)
                cell.priceLbl.isHidden = true
                cell.brandNameLbl.text = searchArray?.list[indexPath.row].name
                cell.followersCountLbl.isHidden = true
                cell.brandImage.downloadCachedImageWithLoader(placeholder: "placeholder", urlString: AppImageUrl.average + (searchArray?.list[indexPath.row].logo ?? ""))
            }
            return cell
        } else if searchType == .restaurant {// restaurant search
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as? restaurantCell else {
                return UITableViewCell()
            }
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
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    //willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Pagination
        if let count = searchArray?.list.count {
            if indexPath.row == count - 2 && hasMore {
                page = page + 1
                if self.searchType == .product {
                    let request = SearchRequest(text: self.searchedText, paginationToken: false, page: page, limit: 25)
                    self.searchVM.search(searchRequest: request)
                } else if self.searchType == .restaurant {
                    // restaurant
                    let request = RestaurantListRequest(longitude: self.longitude, latitude: self.latitude, categories: [], text: self.searchedText)
                    self.restaurantListingVM.fetchRestaurantListing(request: request)
                }
            }
        }
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchType == .product {
            if searchArray?.list[indexPath.row].isProduct ?? DocumentDefaultValues.Empty.bool {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                vc.productId = searchArray?.list[indexPath.row].id ?? DocumentDefaultValues.Empty.string
                self.navigationController?.pushViewController(vc, animated: false)
            }
            else{
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BrandDetailVC") as! BrandDetailVC
                vc.brandId = searchArray?.list[indexPath.row].id ?? DocumentDefaultValues.Empty.string
                vc.isTransition = false
                self.navigationController?.pushViewController(vc, animated: false)
            }
        } else if searchType == .restaurant {
            let vc = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
            vc.restaurantId = restaurantListArray[indexPath.row].id
            vc.distance = restaurantListArray[indexPath.row].distance
            vc.currentLocation?.latitude = latitude
            vc.currentLocation?.longitude = longitude
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func updateTblHeight() {
        constraintHeightTblView.constant = CGFloat.greatestFiniteMagnitude
        tableView.reloadData()
        tableView.layoutIfNeeded()
        constraintHeightTblView.constant = tableView.contentSize.height
    }
}

//MARK: - SearchDelegate
extension SearchVC: SearchDelegate{
    func didRecieveSearchResponse(response: SearchResponse) {
        log.success(response.message)/
        self.shimmerView.hideSkeleton()
        self.shimmerView.isHidden = true
        searchTextfield.resignFirstResponder()
        searchArray = response.data
        
        if page == 1 {
            self.searchArray?.list.removeAll()
        }
        
        if let list = response.data?.list {
            searchArray?.list += list
        }
        DispatchQueue.main.async {
            self.updateTblHeight()
        }
    }
}

//MARK: - RestaurantListingDelegate
extension SearchVC: RestaurantListingDelegate {
    func didRecieveRestaurantListResponse(response: RestaurantListingResponse) {
        log.success(response.message)/
        self.shimmerView.hideSkeleton()
        self.shimmerView.isHidden = true
        
        if page == 1 {
            restaurantListArray = [RestaurantListing]()
        }
        
        restaurantListArray = response.data
        DispatchQueue.main.async {
            self.updateTblHeight()
        }
    }
}
