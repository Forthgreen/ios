//
//  ReportUserRequest.swift
//  forthgreen
//
//  Created by MACBOOK on 28/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

struct ReportUserRequest: Encodable {
    var userRef: String?
    var userReportType: REPORT_TYPE?
    var feedback: String?
    
    init(userRef: String? = nil, feedback: String? = nil, userReportType: REPORT_TYPE? = nil) {
        self.userRef = userRef
        self.feedback = feedback
        self.userReportType = userReportType
    }
}
