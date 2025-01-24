//
//  PostViewModel.swift
//  Instagram
//
//  Created by milad marandi on 1/10/25.
//

import Foundation

struct PostViewModel:Codable {
     let post:post
    
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
    
    var likesTextLabel:String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        }
        else {
            return "\(post.likes) like"
        }
    }
    
    
    init(post: post) {
        self.post = post
    }
    
    
}
