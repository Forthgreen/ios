//
//  FilterViewModel.swift
//  forthgreen
//
//  Created by MACBOOK on 15/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

protocol FilterDelegate {
    func didRecieveFilterParams(category: [Int])
    func didRecieveCategoryFilterParams(category: [Int], gender: SELECTED_FILTER_GENDER)
}

extension FilterDelegate {
    func didRecieveFilterParams(category: [Int]) { }
    func didRecieveCategoryFilterParams(category: [Int], gender: SELECTED_FILTER_GENDER) { }
}
