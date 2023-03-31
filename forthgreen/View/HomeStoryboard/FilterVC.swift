//
//  FilterVC.swift
//  forthgreen
//
//  Created by MACBOOK on 06/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    
    var clearFilter: Bool = Bool()
    private var category: [Int] = [Int]()
    var delegate: FilterDelegate?
    private var filterBtnType: FILTER_BTN_TYPE = .all
    var filterType: FILTER_TYPE = .food
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var allClearBtn: UIBarButtonItem!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: AppColors.charcol,
//             NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 18)!]
//        self.navigationItem.setHidesBackButton(true, animated: true)
//        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        allClearBtn.setTitleTextAttributes([.font : UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 12)!, .foregroundColor : AppColors.charcol], for: .normal)
        allClearBtn.setTitleTextAttributes([.font : UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 12)!, .foregroundColor : AppColors.charcol], for: .selected)
        allClearBtn.title = STATIC_LABELS.clearBtnTitle.rawValue // "CLEAR"
        switch filterType {
        case .restaurants:
            titleLbl.text = STATIC_LABELS.categories.rawValue
            allClearBtn.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        case .food, .health, .miscellaneous, .drink:
            titleLbl.text = STATIC_LABELS.filter.rawValue// "Filter"
            allClearBtn.setBackgroundImage(UIImage.init(named: "buttob_back"), for: .normal, barMetrics: .default)
        }
        
        
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    //MARK: - viewWillDispear
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    //MARK: - ConfigUI
    private func ConfigUI() {
        viewBtn.layer.cornerRadius = 5
        tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        
        if clearFilter {
            clearFilterSetting()
        }
        else {
            switch filterType {
            case .restaurants:
                viewBtn.setTitle(STATIC_LABELS.viewRestaurants.rawValue, for: .normal)
                FILTER_DATA.RestaurantFilter.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .food:
                viewBtn.setTitle(STATIC_LABELS.viewProducts.rawValue, for: .normal)
                FILTER_DATA.foodFilter.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .health:
                viewBtn.setTitle(STATIC_LABELS.viewProducts.rawValue, for: .normal)
                FILTER_DATA.healthFilter.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .miscellaneous:
                viewBtn.setTitle(STATIC_LABELS.viewProducts.rawValue, for: .normal)
                FILTER_DATA.miscellaneous.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .drink:
                viewBtn.setTitle(STATIC_LABELS.viewProducts.rawValue, for: .normal)
                FILTER_DATA.drinkFilter.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            }
        }
        if category.count <= 0 {
            // all
            allClearBtn.title = STATIC_LABELS.allBtnTitle.rawValue // "ALL"
            filterBtnType = .all
        }
        else {
            // clear
            allClearBtn.title = STATIC_LABELS.clearBtnTitle.rawValue // "CLEAR"
            filterBtnType = .clear
        }
    }
    
    //MARK: - clearFilter
    private func clearFilterSetting() {
        category.removeAll()
        switch filterType {
        case .restaurants:
            break
        case .food:
            for index in 0..<FILTER_DATA.foodFilter.count {
                FILTER_DATA.foodFilter[index].isSelected = false
            }
        case .health:
            for index in 0..<FILTER_DATA.healthFilter.count {
                FILTER_DATA.healthFilter[index].isSelected = false
            }
        case .miscellaneous:
            for index in 0..<FILTER_DATA.miscellaneous.count {
                FILTER_DATA.miscellaneous[index].isSelected = false
            }
        case .drink:
            for index in 0..<FILTER_DATA.drinkFilter.count {
                FILTER_DATA.drinkFilter[index].isSelected = false
            }
        }
    }
    
    //MARK: - allClearBtnIsPressed
    @IBAction func allClearBtnIsPressed(_ sender: UIBarButtonItem) {
        switch filterType {
        case .restaurants:
            if filterBtnType == .all {
                // all
                allClearBtn.title = STATIC_LABELS.clearBtnTitle.rawValue// "CLEAR"
                filterBtnType = .clear
                for i in 0..<FILTER_DATA.RestaurantFilter.count{
                    FILTER_DATA.RestaurantFilter[i].isSelected = false
                }
                
            }
            else {
                // clear
                allClearBtn.title = STATIC_LABELS.allBtnTitle.rawValue// "ALL"
                filterBtnType = .all
                for i in 0..<FILTER_DATA.RestaurantFilter.count{
                    FILTER_DATA.RestaurantFilter[i].isSelected = true
                }
            }
        case .food:
            if filterBtnType == .all {
                // all
                allClearBtn.title = STATIC_LABELS.clearBtnTitle.rawValue// "CLEAR"
                filterBtnType = .clear
                for i in 0..<FILTER_DATA.foodFilter.count{
                    FILTER_DATA.foodFilter[i].isSelected = false
                }
                
            }
            else {
                // clear
                allClearBtn.title = STATIC_LABELS.allBtnTitle.rawValue// "ALL"
                filterBtnType = .all
                for i in 0..<FILTER_DATA.foodFilter.count{
                    FILTER_DATA.foodFilter[i].isSelected = true
                }
            }
        case .health:
            if filterBtnType == .all {
                // all
                allClearBtn.title = STATIC_LABELS.clearBtnTitle.rawValue// "CLEAR"
                filterBtnType = .clear
                for i in 0..<FILTER_DATA.healthFilter.count{
                    FILTER_DATA.healthFilter[i].isSelected = false
                }
                
            }
            else {
                // clear
                allClearBtn.title = STATIC_LABELS.allBtnTitle.rawValue// "ALL"
                filterBtnType = .all
                for i in 0..<FILTER_DATA.healthFilter.count{
                    FILTER_DATA.healthFilter[i].isSelected = true
                }
            }
        case .miscellaneous:
            if filterBtnType == .all {
                // all
                allClearBtn.title = STATIC_LABELS.clearBtnTitle.rawValue// "CLEAR"
                filterBtnType = .clear
                for i in 0..<FILTER_DATA.miscellaneous.count{
                    FILTER_DATA.miscellaneous[i].isSelected = false
                }
                
            }
            else {
                // clear
                allClearBtn.title = STATIC_LABELS.allBtnTitle.rawValue// "ALL"
                filterBtnType = .all
                for i in 0..<FILTER_DATA.miscellaneous.count{
                    FILTER_DATA.miscellaneous[i].isSelected = true
                }
            }
        case .drink:
            if filterBtnType == .all {
                // all
                allClearBtn.title = STATIC_LABELS.clearBtnTitle.rawValue// "CLEAR"
                filterBtnType = .clear
                for i in 0..<FILTER_DATA.drinkFilter.count{
                    FILTER_DATA.drinkFilter[i].isSelected = false
                }
                
            }
            else {
                // clear
                allClearBtn.title = STATIC_LABELS.allBtnTitle.rawValue// "ALL"
                filterBtnType = .all
                for i in 0..<FILTER_DATA.drinkFilter.count{
                    FILTER_DATA.drinkFilter[i].isSelected = true
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - crossBtnIsPressed
    @IBAction func crossBtnIsPressed(_ sender: UIButton) {
        switch filterType {
        case .restaurants:
            self.navigationController?.popViewController(animated: false)
        case .food, .health, .miscellaneous, .drink:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - viewBtnIsPRessed
    @IBAction func viewBtnIsPressed(_ sender: UIButton) {
        category.removeAll()
        switch filterType {
        case .restaurants:
            FILTER_DATA.RestaurantFilter.forEach { (filter) in
                if !filter.isSelected{
                    category.append(filter.id)
                }
            }
            delegate?.didRecieveFilterParams(category: category)
            self.navigationController?.popViewController(animated: false)
        case .food:
            FILTER_DATA.foodFilter.forEach { (filter) in
                if !filter.isSelected{
                    category.append(filter.id)
                }
            }
            delegate?.didRecieveFilterParams(category: category)
            self.dismiss(animated: true, completion: nil)
        case .health:
            FILTER_DATA.healthFilter.forEach { (filter) in
                if !filter.isSelected{
                    category.append(filter.id)
                }
            }
            delegate?.didRecieveFilterParams(category: category)
            self.dismiss(animated: true, completion: nil)
        case .miscellaneous:
            FILTER_DATA.miscellaneous.forEach { (filter) in
                if !filter.isSelected{
                    category.append(filter.id)
                }
            }
            delegate?.didRecieveFilterParams(category: category)
            self.dismiss(animated: true, completion: nil)
        case .drink:
            FILTER_DATA.drinkFilter.forEach { (filter) in
                if !filter.isSelected{
                    category.append(filter.id)
                }
            }
            delegate?.didRecieveFilterParams(category: category)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - TableView DataSource and Delegate MEthods
extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch filterType{
        case .restaurants:
            return FILTER_DATA.RestaurantFilter.count
        case .food:
            return FILTER_DATA.foodFilter.count
        case .health:
            return FILTER_DATA.healthFilter.count
        case .miscellaneous:
            return FILTER_DATA.miscellaneous.count
        case .drink:
            return FILTER_DATA.drinkFilter.count
        }
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    // cellFogRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        switch filterType {
        case .restaurants:
            cell.leadingConstraintOfStackView.constant = 16
            cell.filterImage.isHidden = false
            
            cell.filterImage.image = UIImage(named: FILTER_DATA.RestaurantFilter[indexPath.row].picture)
            cell.filterLbl.text = FILTER_DATA.RestaurantFilter[indexPath.row].name
            cell.checkImage.isHidden = FILTER_DATA.RestaurantFilter[indexPath.row].isSelected
        case .food:
            cell.leadingConstraintOfStackView.constant = 24
            cell.filterImage.isHidden = true
            
            cell.filterLbl.text = FILTER_DATA.foodFilter[indexPath.row].name
            cell.checkImage.isHidden = FILTER_DATA.foodFilter[indexPath.row].isSelected
        case .health:
            cell.leadingConstraintOfStackView.constant = 24
            cell.filterImage.isHidden = true
            
            cell.filterLbl.text = FILTER_DATA.healthFilter[indexPath.row].name
            cell.checkImage.isHidden = FILTER_DATA.healthFilter[indexPath.row].isSelected
        case .miscellaneous:
            cell.leadingConstraintOfStackView.constant = 24
            cell.filterImage.isHidden = true
            
            cell.filterLbl.text = FILTER_DATA.miscellaneous[indexPath.row].name
            cell.checkImage.isHidden = FILTER_DATA.miscellaneous[indexPath.row].isSelected
        case .drink:
            cell.leadingConstraintOfStackView.constant = 24
            cell.filterImage.isHidden = true
            
            cell.filterLbl.text = FILTER_DATA.drinkFilter[indexPath.row].name
            cell.checkImage.isHidden = FILTER_DATA.drinkFilter[indexPath.row].isSelected
        }
        return cell
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? FilterCell
        switch filterType {
        case .restaurants:
            if cell?.checkImage.isHidden == true{
                cell?.checkImage.isHidden = false
                FILTER_DATA.RestaurantFilter[indexPath.row].isSelected = false
            } else {
                cell?.checkImage.isHidden = true
                FILTER_DATA.RestaurantFilter[indexPath.row].isSelected = true
            }
            category.removeAll()
            FILTER_DATA.RestaurantFilter.forEach { (filter) in
                if !filter.isSelected{
                    category.append(filter.id)
                }
            }
        case .food:
            if cell?.checkImage.isHidden == true{
                cell?.checkImage.isHidden = false
                FILTER_DATA.foodFilter[indexPath.row].isSelected = false
            } else {
                cell?.checkImage.isHidden = true
                FILTER_DATA.foodFilter[indexPath.row].isSelected = true
            }
            category.removeAll()
            FILTER_DATA.foodFilter.forEach { (filter) in
                if !filter.isSelected{
                    category.append(filter.id)
                }
            }
        case .health:
            if cell?.checkImage.isHidden == true{
                cell?.checkImage.isHidden = false
                FILTER_DATA.healthFilter[indexPath.row].isSelected = false
            } else {
                cell?.checkImage.isHidden = true
                FILTER_DATA.healthFilter[indexPath.row].isSelected = true
            }
            category.removeAll()
            FILTER_DATA.healthFilter.forEach { (filter) in
                if !filter.isSelected{
                    category.append(filter.id)
                }
            }
        case .miscellaneous:
            if cell?.checkImage.isHidden == true{
                cell?.checkImage.isHidden = false
                FILTER_DATA.miscellaneous[indexPath.row].isSelected = false
            } else {
                cell?.checkImage.isHidden = true
                FILTER_DATA.miscellaneous[indexPath.row].isSelected = true
            }
            category.removeAll()
            FILTER_DATA.miscellaneous.forEach { (filter) in
                if !filter.isSelected{
                    category.append(filter.id)
                }
            }
        case .drink:
            if cell?.checkImage.isHidden == true{
                cell?.checkImage.isHidden = false
                FILTER_DATA.drinkFilter[indexPath.row].isSelected = false
            } else {
                cell?.checkImage.isHidden = true
                FILTER_DATA.drinkFilter[indexPath.row].isSelected = true
            }
            category.removeAll()
            FILTER_DATA.drinkFilter.forEach { (filter) in
                if !filter.isSelected{
                    category.append(filter.id)
                }
            }
        }
        if category.count <= 0 { // all
            allClearBtn.title = STATIC_LABELS.allBtnTitle.rawValue// "ALL"
            filterBtnType = .all
        } else { // clear
            allClearBtn.title = STATIC_LABELS.clearBtnTitle.rawValue // "CLEAR"
            filterBtnType = .clear
        }
    }
}
