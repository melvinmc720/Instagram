//
//  profileHeaderViewModel.swift
//  Instagram
//
//  Created by milad marandi on 12/27/24.
//

import Foundation
import UIKit

struct profileHeaderViewModel{
    
    var user:User
    var username:String?{
        return self.user.fullname
    }
    var profileImageURL:URL? {
        return URL(string: self.user.profileimage)
    }
    
    var followdButtonText:String {
        if user.iscurrentUser {
            return "Edit Profile"
        }
        
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var numberOfFollowers:NSAttributedString {
        return attributedStatText(value: user.stats.followers, label: "followers")
    }
    
    var numberOfFollowing:NSAttributedString {
        return attributedStatText(value: user.stats.following, label: "following")
    }
    
    var numberOfposts:NSAttributedString {
        return attributedStatText(value: user.stats.posts, label: "posts")
    }
    
    var followButtonBackgroundColor:UIColor {
        return user.iscurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextColor:UIColor {
        return user.iscurrentUser ? .black : .white
    }
    
    init(user:User){
        self.user = user
    }
    
    func attributedStatText(value:Int , label:String) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(
            string: "\(value)\n",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14) ,
                .foregroundColor
                :UIColor.black]
        )
        
        attributedText
            .append(
                NSAttributedString(
                    string: label,
                    attributes: [
                        .font:UIFont.systemFont(ofSize: 14) ,
                        .foregroundColor
                        :UIColor.lightGray]
                )
            )
        
        return attributedText
        
    }

    
}
