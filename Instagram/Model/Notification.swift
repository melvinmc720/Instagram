//
//  Notification.swift
//  Instagram
//
//  Created by milad marandi on 2/7/25.
//

import Foundation
import FirebaseCore

enum NotificationType:Int {
    case like
    case follow
    case comment
    
    var notificationMessage:String {
        switch self{
            
        case .like:
            return "liked your post."
        case .follow:
            return "started following you"
        case .comment:
            return "commented on your post"
        }
    }
    
}

struct Notification{
    let uid:String
    let postImageUrl:String?
    let postId:String?
    let timestamp:Timestamp
    let type:NotificationType
    let id:String
    let userProfileImageUrl:String
    let username:String
    var userIsFollowed = false
    
    init(dictionary:[String:Any]){
        self.id = dictionary["id"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? " "
        self.postImageUrl = dictionary["postImageUrl"] as? String
        self.postId = dictionary["postId"] as? String ?? " "
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.type = NotificationType(
            rawValue: dictionary["type"] as? Int ?? 0
        ) ?? .like
        
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
}
