//
//  CategoryFilterVC.swift
//  forthgreen
//
//  Created by iMac on 7/22/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

class CategoryFilterVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var womenBtn: UIButton!
    @IBOutlet weak var menBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    @IBOutlet weak var womenTabBottomView: UIView!
    @IBOutlet weak var menTabBottomTab: UIView!
    @IBOutlet weak var viewProductBtn: UIButton!
    
    private var seletedGender: SELECTED_FILTER_GENDER = .women
    var selectedFilter: SELECTED_FILTER_CATEGORY = .clothing
    private var category: [Int] = [Int]()
    var delegate: FilterDelegate?
    var clearFilter: Bool = Bool()
    private var filterBtnType: FILTER_BTN_TYPE = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBar:CustomTabBarController = self.tabBarController as? CustomTabBarController {
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    //MARK: - configUI
    private func configUI() {
        tblView.register(UINib(nibName: TABLE_VIEW_CELL.FilterSelectedTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.FilterSelectedTVC.rawValue)
        
        viewProductBtn.sainiCornerRadius(radius: 3.0)
        clearBtn.sainiCornerRadius(radius: 16.0)
        
        clickToGenderTab(womenBtn)
        if clearFilter {
            clearFilterSetting()
        }
        else {
            defaultSetting()
        }
    }
    
    //MARK: - clearFilter
    private func clearFilterSetting() {
        category.removeAll()
        switch seletedGender {
        case .women:
            switch selectedFilter {
            case .Accessories:
                for index in 0..<FILTER_DATA.accessoriesForWomen.count {
                    FILTER_DATA.accessoriesForWomen[index].isSelected = false
                }
            case .beauty:
                for index in 0..<FILTER_DATA.beautyForWomen.count {
                    FILTER_DATA.beautyForWomen[index].isSelected = false
                }
            case .clothing:
                for index in 0..<FILTER_DATA.clothingForWomen.count {
                    FILTER_DATA.clothingForWomen[index].isSelected = false
                }
            }
        case .men:
            switch selectedFilter {
            case .Accessories:
                for index in 0..<FILTER_DATA.accessoriesForMen.count {
                    FILTER_DATA.accessoriesForMen[index].isSelected = false
                }
            case .beauty:
                for index in 0..<FILTER_DATA.beautyForMen.count {
                    FILTER_DATA.beautyForMen[index].isSelected = false
                }
            case .clothing:
                for index in 0..<FILTER_DATA.clothingForMen.count {
                    FILTER_DATA.clothingForMen[index].isSelected = false
                }
            }
        }
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    //MARK: - defaultSetting
    private func defaultSetting() {
        category.removeAll()
        switch seletedGender {
        case .women:
            switch selectedFilter {
            case .Accessories:
                FILTER_DATA.accessoriesForWomen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .beauty:
                FILTER_DATA.beautyForWomen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .clothing:
                FILTER_DATA.clothingForWomen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            }
        case .men:
            switch selectedFilter {
            case .Accessories:
                FILTER_DATA.accessoriesForMen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .beauty:
                FILTER_DATA.beautyForMen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .clothing:
                FILTER_DATA.clothingForMen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            }
        }
        if category.count <= 0 {
            // all
            clearBtn.setTitle(STATIC_LABELS.allBtnTitle.rawValue, for: .normal)  // "ALL"
            filterBtnType = .all
        }
        else {
            // clear
            clearBtn.setTitle(STATIC_LABELS.clearBtnTitle.rawValue, for: .normal) // "CLEAR"
            filterBtnType = .clear
        }
    }
    
    //MARK:- Button Click
    @IBAction func clickToCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - clickToClear
    @IBAction func clickToClear(_ sender: Any) {
        switch seletedGender {
        case .women:
            switch selectedFilter {
            case .clothing:
                if filterBtnType == .all {  // all
                    clearBtn.setTitle(STATIC_LABELS.clearBtnTitle.rawValue, for: .normal)// "CLEAR"
                    filterBtnType = .clear
                    for i in 0..<FILTER_DATA.clothingForWomen.count{
                        FILTER_DATA.clothingForWomen[i].isSelected = false
                    }
                }
                else {  // clear
                    clearBtn.setTitle(STATIC_LABELS.allBtnTitle.rawValue, for: .normal) // "ALL"
                    filterBtnType = .all
                    for i in 0..<FILTER_DATA.clothingForWomen.count{
                        FILTER_DATA.clothingForWomen[i].isSelected = true
                    }
                }
            case .beauty:
                if filterBtnType == .all {  // all
                    clearBtn.setTitle(STATIC_LABELS.clearBtnTitle.rawValue, for: .normal)// "CLEAR"
                    filterBtnType = .clear
                    for i in 0..<FILTER_DATA.beautyForWomen.count{
                        FILTER_DATA.beautyForWomen[i].isSelected = false
                    }
                }
                else {  // clear
                    clearBtn.setTitle(STATIC_LABELS.allBtnTitle.rawValue, for: .normal) // "ALL"
                    filterBtnType = .all
                    for i in 0..<FILTER_DATA.beautyForWomen.count{
                        FILTER_DATA.beautyForWomen[i].isSelected = true
                    }
                }
            case .Accessories:
                if filterBtnType == .all {  // all
                    clearBtn.setTitle(STATIC_LABELS.clearBtnTitle.rawValue, for: .normal)// "CLEAR"
                    filterBtnType = .clear
                    for i in 0..<FILTER_DATA.accessoriesForWomen.count{
                        FILTER_DATA.accessoriesForWomen[i].isSelected = false
                    }
                }
                else {  // clear
                    clearBtn.setTitle(STATIC_LABELS.allBtnTitle.rawValue, for: .normal) // "ALL"
                    filterBtnType = .all
                    for i in 0..<FILTER_DATA.accessoriesForWomen.count{
                        FILTER_DATA.accessoriesForWomen[i].isSelected = true
                    }
                }
            }
        case .men:
            switch selectedFilter {
            case .clothing:
                if filterBtnType == .all {  // all
                    clearBtn.setTitle(STATIC_LABELS.clearBtnTitle.rawValue, for: .normal)// "CLEAR"
                    filterBtnType = .clear
                    for i in 0..<FILTER_DATA.clothingForMen.count{
                        FILTER_DATA.clothingForMen[i].isSelected = false
                    }
                }
                else {  // clear
                    clearBtn.setTitle(STATIC_LABELS.allBtnTitle.rawValue, for: .normal) // "ALL"
                    filterBtnType = .all
                    for i in 0..<FILTER_DATA.clothingForMen.count{
                        FILTER_DATA.clothingForMen[i].isSelected = true
                    }
                }
            case .beauty:
                if filterBtnType == .all {  // all
                    clearBtn.setTitle(STATIC_LABELS.clearBtnTitle.rawValue, for: .normal)// "CLEAR"
                    filterBtnType = .clear
                    for i in 0..<FILTER_DATA.beautyForMen.count{
                        FILTER_DATA.beautyForMen[i].isSelected = false
                    }
                }
                else {  // clear
                    clearBtn.setTitle(STATIC_LABELS.allBtnTitle.rawValue, for: .normal) // "ALL"
                    filterBtnType = .all
                    for i in 0..<FILTER_DATA.beautyForMen.count{
                        FILTER_DATA.beautyForMen[i].isSelected = true
                    }
                }
            case .Accessories:
                if filterBtnType == .all {  // all
                    clearBtn.setTitle(STATIC_LABELS.clearBtnTitle.rawValue, for: .normal)// "CLEAR"
                    filterBtnType = .clear
                    for i in 0..<FILTER_DATA.accessoriesForMen.count{
                        FILTER_DATA.accessoriesForMen[i].isSelected = false
                    }
                }
                else {  // clear
                    clearBtn.setTitle(STATIC_LABELS.allBtnTitle.rawValue, for: .normal) // "ALL"
                    filterBtnType = .all
                    for i in 0..<FILTER_DATA.accessoriesForMen.count{
                        FILTER_DATA.accessoriesForMen[i].isSelected = true
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    //MARK: - clickToGenderTab
    @IBAction func clickToGenderTab(_ sender: UIButton) {
        womenTabBottomView.backgroundColor = .clear
        menTabBottomTab.backgroundColor = .clear
        
        if sender.tag == 1 {
            womenTabBottomView.backgroundColor = AppColors.turqoiseGreen
            seletedGender = .women
        }
        else{
            menTabBottomTab.backgroundColor = AppColors.turqoiseGreen
            seletedGender = .men
        }
        defaultSetting()
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    //MARK: - clicKToViewProduct
    @IBAction func clicKToViewProduct(_ sender: Any) {
        category.removeAll()
        switch seletedGender {
        case .women:
            switch selectedFilter {
            case .clothing:
                FILTER_DATA.clothingForWomen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
                for index in 0..<FILTER_DATA.clothingForMen.count {
                    FILTER_DATA.clothingForMen[index].isSelected = false
                }
            case .beauty:
                FILTER_DATA.beautyForWomen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
                for index in 0..<FILTER_DATA.beautyForMen.count {
                    FILTER_DATA.beautyForMen[index].isSelected = false
                }
            case .Accessories:
                FILTER_DATA.accessoriesForWomen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
                for index in 0..<FILTER_DATA.accessoriesForMen.count {
                    FILTER_DATA.accessoriesForMen[index].isSelected = false
                }
            }
        case .men:
            switch selectedFilter {
            case .clothing:
                FILTER_DATA.clothingForMen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
                for index in 0..<FILTER_DATA.clothingForWomen.count {
                    FILTER_DATA.clothingForWomen[index].isSelected = false
                }
            case .beauty:
                FILTER_DATA.beautyForMen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
                for index in 0..<FILTER_DATA.beautyForWomen.count {
                    FILTER_DATA.beautyForWomen[index].isSelected = false
                }
            case .Accessories:
                FILTER_DATA.accessoriesForMen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
                for index in 0..<FILTER_DATA.accessoriesForWomen.count {
                    FILTER_DATA.accessoriesForWomen[index].isSelected = false
                }
            }
        }
        delegate?.didRecieveCategoryFilterParams(category: category, gender: seletedGender) //didRecieveFilterParams(category: category)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension CategoryFilterVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch seletedGender {
        case .women:
            switch selectedFilter {
            case .clothing        : return FILTER_DATA.clothingForWomen.count
            case .beauty          : return FILTER_DATA.beautyForWomen.count
            case .Accessories     : return FILTER_DATA.accessoriesForWomen.count
            }
        case .men:
            switch selectedFilter {
            case .clothing        : return FILTER_DATA.clothingForMen.count
            case .beauty          : return FILTER_DATA.beautyForMen.count
            case .Accessories     : return FILTER_DATA.accessoriesForMen.count
            }
        }        
    }
        
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66 //UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.FilterSelectedTVC.rawValue, for: indexPath) as? FilterSelectedTVC else { return UITableViewCell() }
        switch seletedGender {
        case .women:
            switch selectedFilter {
            case .clothing:
                cell.filterLbl.text = FILTER_DATA.clothingForWomen[indexPath.row].name
                cell.checkImage.isHidden = FILTER_DATA.clothingForWomen[indexPath.row].isSelected
            case .beauty:
                cell.filterLbl.text = FILTER_DATA.beautyForWomen[indexPath.row].name
                cell.checkImage.isHidden = FILTER_DATA.beautyForWomen[indexPath.row].isSelected
            case .Accessories:
                cell.filterLbl.text = FILTER_DATA.accessoriesForWomen[indexPath.row].name
                cell.checkImage.isHidden = FILTER_DATA.accessoriesForWomen[indexPath.row].isSelected
            }
        case .men:
            switch selectedFilter {
            case .clothing:
                cell.filterLbl.text = FILTER_DATA.clothingForMen[indexPath.row].name
                cell.checkImage.isHidden = FILTER_DATA.clothingForMen[indexPath.row].isSelected
            case .beauty:
                cell.filterLbl.text = FILTER_DATA.beautyForMen[indexPath.row].name
                cell.checkImage.isHidden = FILTER_DATA.beautyForMen[indexPath.row].isSelected
            case .Accessories:
                cell.filterLbl.text = FILTER_DATA.accessoriesForMen[indexPath.row].name
                cell.checkImage.isHidden = FILTER_DATA.accessoriesForMen[indexPath.row].isSelected
            }
        }
        return cell
    }
        
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? FilterSelectedTVC
        switch seletedGender {
        case .women:
            switch selectedFilter {
            case .clothing:
                if cell?.checkImage.isHidden == true{
                    cell?.checkImage.isHidden = false
                    FILTER_DATA.clothingForWomen[indexPath.row].isSelected = false
                } else {
                    cell?.checkImage.isHidden = true
                    FILTER_DATA.clothingForWomen[indexPath.row].isSelected = true
                }
                category.removeAll()
                FILTER_DATA.clothingForWomen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .beauty:
                if cell?.checkImage.isHidden == true{
                    cell?.checkImage.isHidden = false
                    FILTER_DATA.beautyForWomen[indexPath.row].isSelected = false
                } else {
                    cell?.checkImage.isHidden = true
                    FILTER_DATA.beautyForWomen[indexPath.row].isSelected = true
                }
                category.removeAll()
                FILTER_DATA.beautyForWomen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .Accessories:
                if cell?.checkImage.isHidden == true{
                    cell?.checkImage.isHidden = false
                    FILTER_DATA.accessoriesForWomen[indexPath.row].isSelected = false
                } else {
                    cell?.checkImage.isHidden = true
                    FILTER_DATA.accessoriesForWomen[indexPath.row].isSelected = true
                }
                category.removeAll()
                FILTER_DATA.accessoriesForWomen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            }
        case .men:
            switch selectedFilter {
            case .clothing:
                if cell?.checkImage.isHidden == true{
                    cell?.checkImage.isHidden = false
                    FILTER_DATA.clothingForMen[indexPath.row].isSelected = false
                } else {
                    cell?.checkImage.isHidden = true
                    FILTER_DATA.clothingForMen[indexPath.row].isSelected = true
                }
                category.removeAll()
                FILTER_DATA.clothingForMen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .beauty:
                if cell?.checkImage.isHidden == true{
                    cell?.checkImage.isHidden = false
                    FILTER_DATA.beautyForMen[indexPath.row].isSelected = false
                } else {
                    cell?.checkImage.isHidden = true
                    FILTER_DATA.beautyForMen[indexPath.row].isSelected = true
                }
                category.removeAll()
                FILTER_DATA.beautyForMen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            case .Accessories:
                if cell?.checkImage.isHidden == true{
                    cell?.checkImage.isHidden = false
                    FILTER_DATA.accessoriesForMen[indexPath.row].isSelected = false
                } else {
                    cell?.checkImage.isHidden = true
                    FILTER_DATA.accessoriesForMen[indexPath.row].isSelected = true
                }
                category.removeAll()
                FILTER_DATA.accessoriesForMen.forEach { (filter) in
                    if !filter.isSelected{
                        category.append(filter.id)
                    }
                }
            }
            if category.count <= 0 { // all
                clearBtn.setTitle(STATIC_LABELS.allBtnTitle.rawValue, for: .normal)// "ALL"
                filterBtnType = .all
            } else { // clear
                clearBtn.setTitle(STATIC_LABELS.clearBtnTitle.rawValue, for: .normal) // "CLEAR"
                filterBtnType = .clear
            }
        }
    }
}
