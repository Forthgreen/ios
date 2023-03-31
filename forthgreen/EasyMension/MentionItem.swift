//
//  MentionItem.swift
//  EasyMention
//
//  Created by Morteza on 9/29/19.
//

import Foundation

public struct MentionItem {
    var imageUrl: String
    var name: String
//    var userName: String
    var id: String?
    var type: Int?
    
    public init(name: String,id: String, imageURL: String, type: Int){  //, userName: String
        self.name = name
//        self.userName = userName
        self.id = id
        self.imageUrl = imageURL
        self.type = type
    }
    
}
