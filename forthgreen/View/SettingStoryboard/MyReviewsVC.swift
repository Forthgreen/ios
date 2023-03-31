//
//  MyReviewsVC.swift
//  forthgreen
//
//  Created by MACBOOK on 07/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class MyReviewsVC: UIViewController {
    
     @IBOutlet weak var shimmerView: UIView!
    private var reviewVM: RateReviewViewModel = RateReviewViewModel()
    private var rateReviewArray: [RatingAndReview] = [RatingAndReview]()
    private let refreshControl = UIRefreshControl()
    private var hasMore:Bool = false
    private var page = 1
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        reviewVM.delegate = self
        tableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        rateReviewArray.removeAll()
        page = 1
        hasMore = false
        reviewVM.rateReviewList(page:page)
        
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
    }
    
    //MARK: - refreshData
    @objc func refreshData(_ sender: Any) {
        if AppModel.shared.isGuestUser{
                   return
        }
        shimmerView.isHidden = false
        shimmerView.isSkeletonable = true
        shimmerView.showAnimatedGradientSkeleton()
        rateReviewArray.removeAll()
        page = 1
        hasMore = false
        reviewVM.rateReviewList(page:page)
    }
    
    //MARK: - BackBtnIsPRessed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK: - TableView DataSource and Delegate Methods
extension MyReviewsVC: UITableViewDelegate, UITableViewDataSource {
    
    //numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rateReviewArray.count == 0 {
            tableView.sainiSetEmptyMessage("You haven’t reviewed any products yet.")
            return 0
        }
        tableView.restore()
        tableView.separatorStyle = .none
        return rateReviewArray.count
    }
    
    // estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell else {
            return UITableViewCell()
        }
        if rateReviewArray.count > 0{
        cell.reviewTitleLbl.text = rateReviewArray[indexPath.row].title
        cell.reviewTextLbl.increaseLineSpacing(text: rateReviewArray[indexPath.row].review)
        cell.nameLbl.text = rateReviewArray[indexPath.row].name
        cell.renderRatingStar(count: rateReviewArray[indexPath.row].rating)
        cell.renderProfileImage(circle:false)
        cell.profileProductImage.downloadCachedImage(placeholder: "rectangle", urlString: AppImageUrl.average + (rateReviewArray[indexPath.row].images.first ?? ""))
        cell.threeDotsBtn.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == rateReviewArray.count - 1 && hasMore == true{
           page = page + 1
           reviewVM.rateReviewList(page:page)
        }
    }
    
}

//MARK:- RateReviewDelegate
extension MyReviewsVC:RateReviewDelegate{
    func didReceiveRateReviewResponse(response: RatingReviewResponse) {
        hasMore = response.hasMore
        rateReviewArray += response.data
        self.refreshControl.endRefreshing()
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

