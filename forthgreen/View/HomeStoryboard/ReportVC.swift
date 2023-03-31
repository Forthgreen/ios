//
//  ReportVC.swift
//  forthgreen
//
//  Created by MACBOOK on 06/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ReportVC: UIViewController {

    private var reportUserVM: ReportUserViewModel = ReportUserViewModel()
    private var reportType: REPORT_TYPE = .none
    var userRef: String = String()
    var isPostReport: Bool = Bool()
    var report: REVIEW_TYPE = .none
    
    private var reportVM: ReportViewModel = ReportViewModel()
    var brandId: String = String()
    var selectedReportReason: Int = Int()
    var otherReasonFeedback: String = String()
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var bottomConstraintOfLoginBtn: NSLayoutConstraint!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
        
//        IQKeyboardManager.shared.enableAutoToolbar = false
//        IQKeyboardManager.shared.enable = false
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.enable = true
    }
    
    //MARK:- ConfigUI
    private func ConfigUI() {
        tableView.register(UINib(nibName: "ReportTypeCell", bundle: nil), forCellReuseIdentifier: "ReportTypeCell")
        tableView.register(UINib(nibName: "ReportOtherTextCell", bundle: nil), forCellReuseIdentifier: "ReportOtherTextCell")
        tableView.register(UINib(nibName: "ReportBtnCell", bundle: nil), forCellReuseIdentifier: "ReportBtnCell")
        
        if report == .user {
            titleLbl.text = "Report Profile"
            headingLbl.text = "Why do you wish to report this profile?"
        }
        else {
            titleLbl.text = "Report Brand"
            headingLbl.text = "Why do you wish to report this brand?"
        }
        
        reportUserVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.reportUserVM.success.value {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReportSentVC") as! ReportSentVC
                vc.reportType = .user
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
//        hideKeyboardWhenTappedAround()
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification(keyboardShowNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - handleKeyboardShowNotification
    @objc private func handleKeyboardShowNotification(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.height)
            bottomConstraintOfLoginBtn.constant = keyboardRectangle.height + 16
        }
    }
    
    //MARK: - hideKeyboard
    @objc func hideKeyboard(notification: Notification) {
        self.bottomConstraintOfLoginBtn.constant = 16
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: - reportBtnIsPressed
    @objc func reportBtnIsPressed(sender: UIButton){
        reportVM.delegate = self
        if isPostReport {
            if reportType == .none {
                self.view.sainiShowToast(message: "Kindly mention reason to report")
            }
            else if reportType == .others {
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! ReportOtherTextCell
                otherReasonFeedback = cell.otherTextView.text
                let request = ReportUserRequest(userRef: userRef, feedback: otherReasonFeedback, userReportType: reportType)
                reportUserVM.reportUser(request: request)
            }
            else {
                let request = ReportUserRequest(userRef: userRef, userReportType: reportType)
                reportUserVM.reportUser(request: request)
            }
        }
        else {
            if selectedReportReason == 0 {
                self.view.sainiShowToast(message: "Kindly mention reason to report")
            }
            else if selectedReportReason == 4 {
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! ReportOtherTextCell
                otherReasonFeedback = cell.otherTextView.text
                let request = ReportRequest(reportType: 1, reviewRef: "", brandRef: brandId, brandReportType: selectedReportReason, feedback: otherReasonFeedback)
                reportVM.report(reportRequest: request)
            }
            else {
                let request = ReportRequest(reportType: 1, reviewRef: "", brandRef: brandId, brandReportType: selectedReportReason, feedback: "")
                reportVM.report(reportRequest: request)
            }
        }
    }
    
    @IBAction func clicKToReport(_ sender: Any) {
        reportVM.delegate = self
        if isPostReport {
            if reportType == .none {
                self.view.sainiShowToast(message: "Kindly mention reason to report")
            }
            else if reportType == .others {
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! ReportOtherTextCell
                otherReasonFeedback = cell.otherTextView.text
                let request = ReportUserRequest(userRef: userRef, feedback: otherReasonFeedback, userReportType: reportType)
                reportUserVM.reportUser(request: request)
            }
            else {
                let request = ReportUserRequest(userRef: userRef, userReportType: reportType)
                reportUserVM.reportUser(request: request)
            }
        }
        else {
            if selectedReportReason == 0 {
                self.view.sainiShowToast(message: "Kindly mention reason to report")
            }
            else if selectedReportReason == 4 {
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! ReportOtherTextCell
                otherReasonFeedback = cell.otherTextView.text
                let request = ReportRequest(reportType: 1, reviewRef: "", brandRef: brandId, brandReportType: selectedReportReason, feedback: otherReasonFeedback)
                reportVM.report(reportRequest: request)
            }
            else {
                let request = ReportRequest(reportType: 1, reviewRef: "", brandRef: brandId, brandReportType: selectedReportReason, feedback: "")
                reportVM.report(reportRequest: request)
            }
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension ReportVC: UITableViewDataSource, UITableViewDelegate {
    // numberOfSection
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        else if section == 1 {
            if selectedReportReason == 4 {
                return 1
            }
            return 0
        }
        else {
            return 0//1
        }
    }
    
    //heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 65
        }
        else if indexPath.section == 1 {
            return 130
        }
        else {
            return 0//150
        }
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTypeCell", for: indexPath) as? ReportTypeCell else {
                return UITableViewCell()
            }
            cell.reportReasonLbl.text = REPORT_REASON.reportArray[indexPath.row]
            if (selectedReportReason - 1) == indexPath.row {
                cell.circleImage.image = UIImage(named: "circle_selected")
            }
            else {
                cell.circleImage.image = UIImage(named: "circle_empty")
            }
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportOtherTextCell", for: indexPath) as? ReportOtherTextCell else {
                return UITableViewCell()
            }
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportBtnCell", for: indexPath) as? ReportBtnCell else {
                return UITableViewCell()
            }
            cell.reportBtn.addTarget(self, action: #selector(reportBtnIsPressed), for: .touchUpInside)
            return cell
        }
    }
    
    // didSelect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? ReportTypeCell
            if cell?.circleImage.image == UIImage(named: "circle_empty"){
                cell?.circleImage.image = UIImage(named: "circle_selected")
                self.selectedReportReason = indexPath.row + 1
                reportType = REPORT_TYPE(rawValue: indexPath.row + 1) ?? .none
            }
            else {
                cell?.circleImage.image = UIImage(named: "circle_empty")
                self.selectedReportReason = 0
                reportType = REPORT_TYPE(rawValue: 0) ?? .none
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - ReportDelegate
extension ReportVC: ReportDelegate {
    func didRecieveReportResponse(response: SuccessModel) {
        log.success(response.message)/
        AppDelegate().sharedDelegate().showErrorToast(message: response.message, true)
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReportSentVC") as! ReportSentVC
        vc.isReviewReported = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
