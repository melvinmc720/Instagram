//
//  Post.swift
//  Instagram
//
//  Created by milad marandi on 1/10/25.
//

import Foundation
import FirebaseCore
import UIKit

struct post:Codable {
    var caption:String
    var likes:Int
    var imageURL:String
    var ownerID:String
    var timestamp:Timestamp
    var postID:String
    var ownerImageURL:String
    var ownerUsername:String
    
    init(postID:String , dictionary:[String:Any]){
        self.postID = postID
        self.caption = dictionary["caption"] as? String ?? " "
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageURL = dictionary["imageURL"] as? String ?? " "
        self.ownerID = dictionary["ownerID"] as? String ?? " "
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerImageURL = dictionary["ownerImageURL"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
