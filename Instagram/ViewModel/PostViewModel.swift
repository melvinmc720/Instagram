//
//  PostViewModel.swift
//  Instagram
//
//  Created by milad marandi on 1/10/25.
//

import Foundation

struct PostViewModel:Codable {
    private let post:post
    
    var imageURL:URL? {
        return URL(string: post.imageURL)
    }
    
    var caption:String {
        return post.caption
    }
    
    var likes:Int {
        return post.likes
    }
    
    
    init(post: post) {
        self.post = post
    }
    
    
}
