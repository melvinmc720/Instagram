//
//  PostViewModel.swift
//  Instagram
//
//  Created by milad marandi on 1/10/25.
//

import Foundation
import UIKit

struct PostViewModel:Codable {
    var post:post
    
    var imageURL:URL? {
        return URL(string: post.imageURL)
    }
    
    var userProfileImage: URL? { return URL(string: post.ownerImageURL)}
    
    var username:String {
        return post.ownerUsername
    }
    
    var caption:String {
        return post.caption
    }
    
    var likes:Int {
        return post.likes
    }
    
    var likeButtonColor:UIColor {
        return post.isLiked ? .red : .black
    }
    
    var likeButtonImage:UIImage? {
        return post.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    var likesTextLabel:String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        }
        else {
            return "\(post.likes) like"
        }
    }
    
    var timeStampString:String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second , .minute , .hour , .day , .weekOfMonth ]
        
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        
        return formatter.string(from: post.timestamp.dateValue(), to: Date()) ?? "2m"
    }
    
    
    init(post: post) {
        self.post = post
    }
    
    
}
