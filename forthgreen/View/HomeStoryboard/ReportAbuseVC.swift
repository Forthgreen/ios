//
//  ReportAbuseVC.swift
//  forthgreen
//
//  Created by MACBOOK on 06/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class ReportAbuseVC: UIViewController {
    
    private var reportVM: ReportViewModel = ReportViewModel()
    var reviewId: String = String()
    var ref: String = String()
    var reportType: REVIEW_TYPE = .product

    @IBOutlet weak var reportBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //MARK: - ConfigUI
    private func ConfigUI() {
        reportBtn.layer.cornerRadius = 5
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: - reportBtnIsPressed
    @IBAction func reportBtnIsPressed(_ sender: UIButton) {
        reportVM.delegate = self
        if reportType == .product { // product review
            let request = ReportRequest(reportType: 2, reviewRef: reviewId, brandRef: "", brandReportType: 4, feedback: "")
            reportVM.report(reportRequest: request)
        } else if reportType == .restaurant {
            // restuarant Review
            let request = ReportRequest(reportType: 3, reviewRef: reviewId, brandRef: "", brandReportType: 4, feedback: "")
            reportVM.report(reportRequest: request)
        }
    }

}

//MARK: - ReportDelegate
extension ReportAbuseVC: ReportDelegate {
    func didRecieveReportResponse(response: SuccessModel) {
        log.success(response.message)/
        self.view.resignFirstResponder()
        AppDelegate().sharedDelegate().showErrorToast(message: response.message, true)
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ReportSentVC") as! ReportSentVC
        vc.isReviewReported = true
        vc.reportType = reportType
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
