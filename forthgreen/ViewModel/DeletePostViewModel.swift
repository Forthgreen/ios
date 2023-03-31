//
//  DeletePostViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 16/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils

protocol DeletePostDelegate {
    var success: Box<Bool> { get set }
    func deletePost(request: DeletePostRequest)
}

struct DeletePostViewModel: DeletePostDelegate {
    var success: Box<Bool> = Box(Bool())
    
    func deletePost(request: DeletePostRequest) {
        DispatchQueue.global().async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.POST.delete, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.success.value = true
                            break
                        default:
                            log.error("\(Log.stats()) \(success.message)")/
                        }
                    }
                    catch let err {
                        log.error("ERROR OCCURED WHILE DECODING: \(Log.stats()) \(err)")/
                    }
                }
            }
        }
    }
    
}
