//
//  SearchViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 17/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol SearchDelegate {
    func didRecieveSearchResponse(response: SearchResponse)
}

struct SearchViewModel {
    var delegate: SearchDelegate?
    
    func search(searchRequest: SearchRequest){
        let params: [String: Any] = ["text": searchRequest.text,
                                     "paginationToken": searchRequest.paginationToken,
                                     "page": searchRequest.page,
                                     "limit": searchRequest.limit]
        GCD.BRAND.search.async {
            APIManager.sharedInstance.I_AM_COOL(params: params, api: API.BRAND.search, Loader: false, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(SearchResponse.self, from: response!) // decode the response into success model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveSearchResponse(response: success)
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
